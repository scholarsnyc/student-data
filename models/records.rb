class Record
	include DataMapper::Resource
  include DataModel::Attributes

	property :id,						String, :key => true
	property :score,				Integer
	property :exam,					Integer, :required => false
  property :conduct,      String, :required => false
  property :course_id,    String
  property :section,      Integer
	property :mp,						Integer
  property :year,         Integer
	property :import,             Integer, :default => Time.now.to_i
	property :created_at,         DateTime, :default => Time.now
	property :updated_at,         DateTime, :default => Time.now
	
	belongs_to :student
	belongs_to :course	
	
	before :save do
    # Remove benchmark grades of zero
		self.exam = nil if self.exam == 0
	end
	
	before :update do
	  self.updated_at = Time.now
  end
	
	def self.subject(subject)
		all(:course => {:subject => subject})
	end
	
	def self.teacher(teacher)
		all(:course => {:teacher => teacher})
	end
	
	def self.grade(grade)
		all(:student => {:grade => grade})
	end
	
	def self.cohort(cohort)
		all(:student => {:cohort => cohort})
	end
	
	def self.grade_cohort(grade, cohort)
		all(:student => {:grade => grade})
	end
  
  def self.gender(gender)
    gender = [:male,:female].index(gender) if gender.is_a? Symbol
    all(:student => {:gender => gender})
  end
	
  def self.ethnicity(ethnicity)
    all(:student => {:ethnicity => ethnicity})
  end
  
	def self.mp(mp)
		all(:mp => mp)
	end
  
  def self.good_standing
    all(:score.gte => AT_RISK_GRADE)
  end
  
  def self.probationary
    all(:score.lt => AT_RISK_GRADE)
  end
  
  def self.probation_1
    all(:score.gte => AT_RISK_LEVEL_2, :score.lt => AT_RISK_GRADE)
  end
  
  def self.probation_2
    all(:score.gte => PASSING_GRADE, :score.lt => AT_RISK_LEVEL_2)
  end
  
  def self.failing
    all(:score.lt => PASSING_GRADE)
  end
  
  def self.variance(type, format = nil)
    begin
      collection, average = all.map {|record| record[type] }, all.avg(type)
      collection.reject! {|record| record.nil? || !record.integer? || record.zero? }
      collection.map! {|record| (record - average)**2 }
      result = collection.reduce {|sum, n| sum + n } / collection.length.to_f
      return sprintf('%.2f', result) if format == :rounded
      return result
    rescue
      return nil
    end
  end
  
  def self.standard_deviation(type)
    Math.sqrt(all.variance(type))
  rescue
    nil
  end
  
  def self.above(number, type = :exam)
    all(type.gte => number)
  end
  
  def deviance(type, scope = :class, format = nil)
    return nil if self[type].nil?
    if scope == :grade
      records = Record.grade(self.grade).subject(self.subject).mp(self.mp)
    elsif scope == :class
      records = self.course.records.mp(self.mp)
    end
    std = records.mp(self.mp).standard_deviation(type)
    avg = records.mp(self.mp).avg(type)
    rec = self[type]
    result = (rec - avg) / std
    return sprintf('%.2f', result) if format == :rounded
    return result
  rescue
    nil
  end
  
	
	def failing?
		return nil if self.score.nil?
    self.score < PASSING_GRADE
	end
	
	def at_risk?
    return nil if self.score.nil?
		self.score <= AT_RISK_GRADE && self.score >= PASSING_GRADE
	end
	
	def difference
    if self.score && self.exam
      self.score - self.exam
    else
      nil
    end
	end
		
	def state_exam
		if self.course.subject == "English"
			self.student.ela
		elsif self.course.subject == "Mathematics"
			self.student.math
		else
			nil
		end
	end
  
  def subject
    self.course.subject
  end
  
  def grade
    self.student.grade
  end
  
  def cohort
    self.student.cohort
  end

	def change(type = :score, mp_for_comparison = self.mp - 1)
		# Theoretically, this will get the record for the same student in the same period but from a different marking period.
		# The database query should return an array with only one item in it and then this method grabs the first (and only) record.
		# It's a little bit more failsafe than gunning for a particular record that may or may not exist.
		comparison_record = Record.all(:course_code => self.course_code, :student_id => self.student_id, :mp => mp_for_comparison).first
		# Then, we check for possible screw ups (zeroth marking period, no previous record, and nil exam/score from either this marking period or the last.
		self[type] - comparison_record[type] unless mp_for_comparison === 0 || comparison_record.nil? || comparison_record[type].nil? || self[type].nil? || self[type] == nil
	rescue
		return nil
	end

end
