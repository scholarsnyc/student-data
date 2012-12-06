require 'csv'
require '../config/boot'

COURSES = "master_course_list_2013.csv"
GRADES = "T1MP1.csv"

class DataImporter
  attr_accessor :year, :mp
  attr_reader :data
  
  def initialize(datasource, year = CURRENT_YEAR, mp = CURRENT_MARKING_PERIOD)
    @data = CSV.read(datasource)
    @year = year
    @mp = mp
    @import = Time.now.to_i
  end
  
  def process; end
  
end

class CourseImporter < DataImporter  
  def process
    @data.each do |row|
      Course.new(
        course_id: row[0],
        section: row[1],
        name: row[2],
        teacher: row[3],
        import: @import,
        year: @year
      ).set_code.save
    end
  end
end

class RecordImporter < DataImporter 
  def process
    @data.each do |row|
      course = "#{row[5]}#{row[6]}#{@year}"
      Record.create(
        student_id: row[0],
        course_code: course,
        score: row[9],
        exam: row[10],
        conduct: row[11],
        mp: @mp,
        year: @year,
        import: @import
      )
    end
  end
end