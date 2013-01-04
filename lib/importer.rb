require 'csv'

COURSES = "./data/master_course_list_2013.csv"
GRADES = "./data/T1MP1.csv"

class DataImporter
  attr_accessor :year, :mp
  attr_reader :data
  
  def initialize(datasource, year = CURRENT_YEAR, mp = CURRENT_MARKING_PERIOD)
    @data = CSV.read(datasource)
    @year = year
    @mp = mp
    @import = Time.now.to_i
    @courses = Course.codes
    @students = Student.ids
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

  def format_row(row)
    {
      score: row[9],
      exam: row[10],
      conduct: row[11],
      course_id: row[5],
      section: row[6],
      mp: @mp,
      year: @year,
      import: @import,
      student_id: row[0],
      course_code: "#{row[5]}#{row[6]}#{@year}",
      id: "#{row[5]}#{row[6]}#{@mp}#{row[0]}#{@year}"
    }
  end
  
  def eligible?(row)
    student = row[0]
    course = "#{row[5]}#{row[6]}#{@year}"
    @students.include?(student) && @courses.include?(course)
  end
  
  def process
    @data.each do |row|
      if eligible?(row)
        Record.create(format_row(row))
      end
    end
  end
end