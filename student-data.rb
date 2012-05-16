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

CURRENT_MARKING_PERIOD = 5
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
          ComprehensiveReport.new(Student.all(g[:opts]), s).to_a[0..4]
        ].flatten 
      end
    }
  end
  
  erb :charts
end

get '/test' do
  @data = Grade.new(7).to_comprehensive_report(:ela)
  erb :test
end