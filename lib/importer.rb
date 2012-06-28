require 'csv'
require 'json'
require 'fileutils'

class Importer
  attr_reader :data, :filename

  def initialize(csv, type, timestamp = Time.now.to_i)
    raise ArgumentError, "Type must be a class" unless type.is_a? Class
    raise ArgumentError, "You must provide a CSV" unless /\.csv$/.match(csv)
    raw_data = CSV.open(csv, 'rb').to_a[1..100000]
    @type = type
    @filename = /(.+)\.csv/.match(csv)[1]
    @timestamp = timestamp
    @data = inflate raw_data
  end

  def to_json
    @data.to_json
  end

  def save_to_db
    @data.each do |data|
      next if Record.get(data[:id])
      next if data[:student_id] && (Student.get(data[:student_id]).nil? || data[:student_id].nil?)
      next if data[:score] && data[:score] == 0
      next if @type == Record && (Student.get(data[:student_id]).nil? || Course.get(data[:course_code]).nil?)

      @type.create data
    end
  end
end

class RecordImporter < Importer
  attr_reader :mp
	def initialize(csv, timestamp = Time.now.to_i)
    @mp = /records-mp(\d)\.csv$/.match(csv)[1].to_i
    super(csv, Record, timestamp)
	end

  private

  def inflate(array)
    array.map do |r|
      course_id = CourseChanges.update_course(r[5])
      {
        :import => @timestamp,
        :id => [course_id,r[6],@mp,r[0]].join(),
        :student_id => r[0],
        :mp => @mp,
        :course_id => course_id,
        :score => r[9],
        :exam => r[10],
        :section => r[6],
        :conduct => r[7],
        :course_code => [course_id,r[6]].join()
      }
    end
  end
end

class StudentImporter < Importer
  def initialize(csv, timestamp = Time.now.to_i)
    super(csv, Student, timestamp)
    raise ArgumentError, "You must provide a CSV full of students." unless /students.+\.csv$/.match(csv)
  end

  private

  def inflate(array)
    array.map do |student|
      {
        :import => @timestamp,
        :id => student[0].to_i,
        :firstname => student[1],
        :lastname => student[2],
        :grade => student[3].to_i,
        :homeroom => student[4],
        :gender => student[7],
        :ethnicity => student[5].to_i,
        :language => student[6]
      }
    end
  end
end

class CourseImporter < Importer
  def initialize(csv, timestamp = Time.now.to_i)
    super(csv, Course, timestamp)
    raise ArgumentError, "You must provide a CSV full of courses." unless /courses.+\.csv$/.match(csv)
  end

  private

  def inflate(array)
    array.map do |course|
      course_id = CourseChanges.update_course(course[3])
      course_code = [course_id,course[4]].join()
      {
        :import => @timestamp,
        :code => course_code,
        :name => course[1],
        :teacher => course[2],
        :course_id => course_id,
        :section => course[4],
        :subject => course[5]
      }
    end
  end
end

class ExamImporter < Importer
  def initialize(csv, timestamp)
    super(csv, Exam, timestamp)
    raise ArgumentError, "You must provide a CSV full of courses." unless /exams.+\.csv$/.match(csv)
  end

  private

  def inflate(array)
    array.map do |exam|
      {
        :import => @timestamp,
        :student_id => exam[0].to_i,
        :score => exam[1].to_f,
        :type => exam[2],
        :comment => exam[3],
        :mp => exam[4],
        :year => exam[5]
      }
    end
  end
end