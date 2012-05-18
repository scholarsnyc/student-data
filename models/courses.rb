class Course
	include DataMapper::Resource
  include DataModel::Attributes

	property :code,				String, :key => true
	property :name,				String
	property :teacher,		String
	property :course_id,	String
	property :section,		Integer
	property :subject,		String
	property :import,     Integer, :default => Time.now.to_i
	property :created_at, DateTime, :default => Time.now
	property :updated_at, DateTime, :default => Time.now
	
	before :update do
	  self.updated_at = Time.now
  end
	
	has n, :records
	has n, :students, :through => :records
	
	def self.subject(subject)
		all(:subject => subject)
	end
	
	def self.subjects
		all.map{|x| x.subject}.uniq.sort
	end
	
	def self.teachers
		all.map{|x| x.teacher}.uniq.sort
	end
	
	def self.teacher(teacher)
		all(:teacher => teacher)
	end
	
	def self.grade(g)
		all(:records => {:student => {:grade => g}})
	end
	
	def grade
		students.avg(:grade).to_i
	end
	
	def passing(marking_period = CURRENT_MARKING_PERIOD, type_of_score = :score)
		records(type_of_score.gte => PASSING_GRADE, :mp => marking_period)
	end
	
	def failing(marking_period = CURRENT_MARKING_PERIOD, type_of_score = :score)
		records(type_of_score.lt => PASSING_GRADE, :mp => marking_period)
	end
	
	def percent_passing(mp = CURRENT_MARKING_PERIOD, type = :score)
		begin
			passing = passing(marking_period = mp, type_of_score = type).count.to_f
			total = records(:mp => mp).count
			result = passing/total*100
			return result.to_i if result > 0
		rescue
			return nil
		end
	end
	
	def average_score(marking_period = CURRENT_MARKING_PERIOD, type_of_score = :score)
		score = records(:mp	=> marking_period).avg(type_of_score).to_i
		score == 0 ? nil : score
	end
	
  def total_students(mp = 1.upto(CURRENT_MARKING_PERIOD).to_a)
    records.students.uniq
  end
	
	def students_on_probation(mp = 1.upto(CURRENT_MARKING_PERIOD).to_a)
	  records(:score.lt => 75, :mp => mp).students.uniq
  end
  
  def percent_on_probation
    records(:score.lt => 75, :mp => mp).students.uniq * 1.0 / records.students.uniq
  end

	def third(sort = [:lowest, :exam], marking_period = CURRENT_MARKING_PERIOD)
		case sort
		when [:lowest, :exam] then records = self.records(:mp => marking_period, :order => [ :exam.asc ])
		when [:highest, :exam] then records = self.records(:mp => marking_period, :order => [ :exam.desc ])
		when [:lowest, :score] then records = self.records(:mp => marking_period, :order => [ :score.asc ])
		when [:highest, :score] then records = self.records(:mp => marking_period, :order => [ :score.desc ])
		else
			raise "Sorting syntax is wonky."
		end
		number_of_records = records.length
		one_third_of_records = number_of_records / 3
		records.slice!(one_third_of_records..number_of_records)
		records.map! { |record| record.student }
	end
	
	def self.to_breakdown(mp = CURRENT_MARKING_PERIOD)
	  CourseBreakdown.new(all).breakdown
  end
	
	def to_breakdown(mp = CURRENT_MARKING_PERIOD)
	  CourseBreakdown.new(self).breakdown
  end
	
end

class CourseBreakdown
  attr_reader :students
  def initialize(course, mp = CURRENT_MARKING_PERIOD)
    raise ArgumentError unless course.is_a?(DataMapper::Collection) || course.is_a?(Course)
    @course = course
    @students = @course.students
    @records = @course.records.mp(mp)
  end
  
  def above(number)
   ((@records.above(number).count * 1.0) / @records.count).to_percent
  end
  
  def breakdown
    {
      55 => above(55),
      65 => above(65),
      85 => above(85)
    }
  end
end