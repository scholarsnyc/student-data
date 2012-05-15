require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'google_chart'

# Use MySQL in production, but use a local SQLite database in development

configure :development do
 DataMapper.setup(:default, "sqlite://#{Dir.pwd}/data.db")
end

configure :production do
 DataMapper.setup(:default, 'mysql://seawolf:Oce423@scholarsnyc.com/studentdata')
end

# Load up the models and controllers 
# (Sinatra takes care of the views by default)
begin
  ["./lib/importer", "./models/_models"].each {|file| require file}
  Dir["./models/*.rb"].each {|file| require file}
  Dir["./controllers/*.rb"].each {|file| require file}
  Dir["./lib/*.rb"].each {|file| require file}
  DataMapper.finalize
end

# Some constants that get referenced often in the application
APPLICATION_NAME = "Student Assessment Database"

PASSING_GRADE = 65
AT_RISK_GRADE = 75
AT_RISK_LEVEL_2 = 70
OUTSTANDING_GRADE = 80

CURRENT_MARKING_PERIOD = 4
CURRENT_YEAR = Time.now.year

LOWEST_COUNT = 10

HOMEROOMS = Student.homerooms
GRADES = Student.grades
SUBJECTS = Course.subjects

# Get all of the Javascripts in the "./public/js" directory
# The map at the end also strips off the "./public/" prefix from the beginning.
JAVASCRIPTS = Dir["./public/js/*.js"].reverse.map!{|x| x.gsub('./public', '')}

# Set up some really basic password protection
use Rack::Auth::Basic, "Restricted Area" do |username, password|
  [username, password] == ['faculty', 'rockawaytaco']
end

# Before loading a given controller, set the marking period to the current one 
# unless passed a parameter that instructs otherwise
before do
  @marking_period = params[:mp] || CURRENT_MARKING_PERIOD
end

# Basic route for pulling up the home page
get '/' do  
  erb :index  
end

get '/cep' do
  @title = "CEP Reports"
  
  @students = Student.all
  @subjects = {:ela => "English Language Arts", :math => "Mathematics"}

  ms_groups = [
    {:name => "Grade 6", :opts => {:grade => 6}},
    {:name => "Grade 6A", :opts => {:grade => 6, :cohort => :A}},
    {:name => "Grade 6B", :opts => {:grade => 6, :cohort => :B}},
    {:name => "Grade 6C", :opts => {:grade => 6, :cohort => :C}},
    {:name => "Grade 7", :opts => {:grade => 7}},
    {:name => "Grade 7A", :opts => {:grade => 7, :cohort => :A}},
    {:name => "Grade 7B", :opts => {:grade => 7, :cohort => :B}},
    {:name => "Grade 8", :opts => {:grade => 8}},
    {:name => "Grade 8A", :opts => {:grade => 8, :cohort => :A}},
    {:name => "Grade 8B", :opts => {:grade => 8, :cohort => :B}}
  ]
  
  @data = @subjects.keys.map do |s|
    {
      :name => Conversions::Courses::COURSES[s],
      :data => ms_groups.map do |g| 
        [
          g[:name],
          ComprehensiveReport.new(Student.all(g[:opts]), s).to_a
        ].flatten 
      end
    }
  end
  
  @column_titles = [
      "grade",
      {:type => "nys", :subject => "ela", :subgroup => "all"},
      {:type => "nys", :subject => "ela", :subgroup => "lte"},
      {:type => "nys", :subject => "math", :subgroup => "all"},
      {:type => "nys", :subject => "math", :subgroup => "ltm"},
      {:type => "benchmark", :mp => "mp1", :subgroup => "all"},
      {:type => "benchmark", :mp => "mp1", :subgroup => "lte"},
      {:type => "benchmark", :mp => "mp1", :subgroup => "ltm"},
      {:type => "benchmark", :mp => "mp2", :subgroup => "all"},
      {:type => "benchmark", :mp => "mp2", :subgroup => "lte"},
      {:type => "benchmark", :mp => "mp2", :subgroup => "ltm"},
      {:type => "benchmark", :mp => "mp3", :subgroup => "all"},
      {:type => "benchmark", :mp => "mp3", :subgroup => "lte"},
      {:type => "benchmark", :mp => "mp3", :subgroup => "ltm"},
      {:type => "benchmark", :mp => "mp4", :subgroup => "all"},
      {:type => "benchmark", :mp => "mp4", :subgroup => "lte"},
      {:type => "benchmark", :mp => "mp4", :subgroup => "ltm"},
      {:type => "benchmark", :mp => "mp5", :subgroup => "all"},
      {:type => "benchmark", :mp => "mp5", :subgroup => "lte"},
      {:type => "benchmark", :mp => "mp5", :subgroup => "ltm"},
      {:type => "benchmark", :mp => "mp6", :subgroup => "all"},
      {:type => "benchmark", :mp => "mp6", :subgroup => "lte"},
      {:type => "benchmark", :mp => "mp6", :subgroup => "ltm"}
    ]
  
  @data_for_each_subject = [:ela, :socialstudies, :math, :science, :spanish].map do |s|
    {
      :name => Conversions::Courses::COURSES[s],
      :data => ms_groups.map do |g|
        c = ComprehensiveReport.new(@students.all(g[:opts]), s)
        le = ComprehensiveReport.new(@students.lowest_third_ela.all(g[:opts]), s)
        lm = ComprehensiveReport.new(@students.lowest_third_math.all(g[:opts]), s)
        [
          g[:name],
          [
            c.exam_average(:state, :subject => :ela).round,
            le.exam_average(:state, :subject => :ela).round,
            c.exam_average(:state, :subject => :math).round,
            lm.exam_average(:state, :subject => :math).round,
            c.average(:exam, :mp => 1).round,
            le.average(:exam, :mp => 1).round,
            lm.average(:exam, :mp => 1).round,
            c.average(:exam, :mp => 2).round,
            le.average(:exam, :mp => 2).round,
            lm.average(:exam, :mp => 2).round,
            c.average(:exam, :mp => 3).round,
            le.average(:exam, :mp => 3).round,
            lm.average(:exam, :mp => 3).round,
            c.average(:exam, :mp => 4).round,
            le.average(:exam, :mp => 4).round,
            lm.average(:exam, :mp => 4).round,
            c.average(:exam, :mp => 5).round,
            le.average(:exam, :mp => 5).round,
            lm.average(:exam, :mp => 5).round,
            c.average(:exam, :mp => 6).round,
            le.average(:exam, :mp => 6).round,
            lm.average(:exam, :mp => 6).round
          ]
        ].flatten
      end
    }
  end
  
  erb :charts
end

get '/rebuild' do
  DataImport.rebuild!
  erb :index
end