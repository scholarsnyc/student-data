class Student
  include DataMapper::Resource
  include LowestStudents

  property :id,                 Integer, :key => true
  property :firstname,          String
  property :lastname,           String
  property :grade,              Integer 
  property :previous_grade,     Integer
  property :homeroom,           Integer
  property :previous_homeroom, 	Integer
  property :cohort,             String
  property :previous_cohort,    String
  property :gender,             Integer
  property :ethnicity,          Integer
  property :language,           String
  property :iep,                Integer
  property :lowest_third_ela,   Boolean, :default => false
  property :lowest_third_math,  Boolean, :default => false
  property :import,             Integer, :default => Time.now.to_i
	property :created_at,         DateTime, :default => Time.now
	property :updated_at,         DateTime, :default => Time.now
  
  has n, :records
  has n, :exams
  has n, :courses, :through => :records
  
  before :save do
    self.lowest_third_ela = true if LOWEST_THIRD_ELA.include?(self.id)
    self.lowest_third_math = true if LOWEST_THIRD_MATH.include?(self.id)
    self.cohort = self.in_cohort
    self.previous_cohort = self.in_previous_cohort
  end
  
  before :update do
	  self.updated_at = Time.now
  end
  
  # Redefine the default query to only look for current students
  # TODO: This is probably going to break.
  def self.all(query = {:homeroom.not => nil})  
    super(query)    
  end

  # ============= #
  # Class Methods #
  # ============= #
  
  def self.homerooms
    all.map{|x| x.homeroom}.delete_if {|x| x == nil}.uniq.sort
  end
  
  def self.grades
    all.map{|x| x.grade}.delete_if {|x| x == nil}.uniq.sort
  end
  
  def self.cohorts
    all.map{|x| x.cohort unless x.hs?}.uniq.sort.delete_if {|x| x.nil?}
  end
  
  def self.has_cohorts?
    !cohorts.empty?
  end
  
  def self.ethnicities
    all.map{|x| x.ethnicity}.uniq.sort
  end
  
  def self.languages
    all.map{|x| x.language}.uniq.sort
  end
  
  def self.targeted
    all(:targeted => true)
  end
  
  def self.grade(grade)
    all(:grade => grade)
  end
  
  def self.gender(gender)
      {:male => 0, :female => 1}[gender] if gender.is_a? Symbol
      all(:gender => gender)
  end

  def self.cohort(cohort)
    all(:cohort => cohort.upcase)
  end
  
  def self.middleschool
    all(:grade.gte => 6, :grade.lte => 8)
  end
  
  def self.lowest_third_ela(switch = true)
    all(:lowest_third_ela => switch)
  end
  
  def self.lowest_third_math(switch = true)
    all(:lowest_third_math => switch)
  end
  
  def self.highschool
    all(:grade.gte => 9, :grade.lte => 12)
  end
  
  def self.good_standing(marking_period = CURRENT_MARKING_PERIOD)
    all(:records => {:score.gte => PASSING_GRADE, :mp => marking_period}) - self.on_probation(marking_period)
  end
  
  def self.on_probation(marking_period = CURRENT_MARKING_PERIOD)
    all(:records => {:score.lt => AT_RISK_GRADE, :mp => marking_period})
  end 
  
  def self.probation_1(marking_period = CURRENT_MARKING_PERIOD)
    all(:records => {:score.lt => AT_RISK_GRADE, :score.gte => AT_RISK_LEVEL_2, :mp => marking_period}) - self.probation_2(marking_period) - self.failing(marking_period)
  end
  
  def self.probation_2(marking_period = CURRENT_MARKING_PERIOD)
    all(:records => {:score.lt => AT_RISK_LEVEL_2, :score.gte => PASSING_GRADE, :mp => marking_period}) - self.failing(marking_period)
  end
  
  def self.failing(marking_period = CURRENT_MARKING_PERIOD)
    all(:records => {:score.lt => PASSING_GRADE, :mp => marking_period})
  end
  
  def self.ineligible(marking_period = CURRENT_MARKING_PERIOD)
    all(:records => {:score.lt => AT_RISK_LEVEL_2, :mp => marking_period})
  end

  def self.not_college_ready
    all(:grade => [9,10,11,12]).delete_if do |student|
      student.college_ready? == true || student.college_ready?.nil?
    end
  end
  
  def self.to_comprehensive_report(subject, options = {})
    ComprehensiveReport.new(all, subject, options)
  end

  # ================ #
  # Instance Methods #
  # ================ #

  def name
    self.firstname + " " + self.lastname
  end
  
  # Translate the number codes for gender and ethnicity to human-readable text
  
  def gender_to_s
    ["Male","Female"][self.gender]
  end
  
  def ethnicity_to_s
    ["Unknown", "American Indian or Alaskan Native", "Asian", "Hispanic or Latino", "Black or African American", "White"][self.ethnicity]
  end
  
  # Determines what cohort a student is in if they're in the middle school.
  # This seems redundant, but don't delete it. Trust me.
  # It's used for setting their cohort in when saving a student to the database.
  
  def in_cohort
    if self.homeroom.to_s =~ /[6-8]\d[1-3]/
      cohort = :A
    elsif self.homeroom.to_s =~ /[6-8]\d[4-6]/
      cohort = :B
    elsif self.homeroom.to_s =~ /[6-8]\d[7-9]/
      cohort = :C
    else
      nil
    end
  end

  def in_previous_cohort
    if self.previous_homeroom.to_s =~ /[6-8]\d[1-3]/
      cohort = :A
    elsif self.previous_homeroom.to_s =~ /[6-8]\d[4-6]/
      cohort = :B
    elsif self.previous_homeroom.to_s =~ /[6-8]\d[7-9]/
      cohort = :C
    else
      nil
    end
  end
  
  # Generates a list of courses at a given probation level.
  
  def probation(marking_period = CURRENT_MARKING_PERIOD) 
    # Pulls up student records that meet the criteria for a certain level of probation.
    {
      :failing => self.records(:score.lt => PASSING_GRADE, :mp => marking_period),
      :probation_2 => self.records(:score.lt => AT_RISK_LEVEL_2, :score.gte => PASSING_GRADE, :mp => marking_period),
      :probation_1 => self.records(:score.lt => AT_RISK_GRADE, :score.gte => AT_RISK_LEVEL_2, :mp => marking_period)
    }
  end

  def status(argument = :symbol) # Based on the records that meet the probation criteria, what's the most severe?
    case argument
    when :symbol
      if !self.probation[:failing].empty?
        return :failing
      elsif !self.probation[:probation_2].empty?
        return :probation_2
      elsif !self.probation[:probation_1].empty?
        return :probation_1
      else
        return :normal
      end
    when :string
      if !self.probation[:failing].empty?
        return "Probation: Level 2+"
      elsif !self.probation[:probation_2].empty?
        return "Probation: Level 2"
      elsif !self.probation[:probation_1].empty?
        return "Probation: Level 1"
      else
        return "Not on Probation"
      end
    end
  end
  
  def subject_list(type) # For what courses is a student on probation?
    courses = Array.new
    self.probation[type].each do |course|
      courses << course.course.subject
    end
    return courses.join(", ")
  end
  
  def average_score(mp = CURRENT_MARKING_PERIOD) # Generates an unweighted average of report card scores for a given marking period.
    if mp == :all
      self.records.avg(:score)
    else
      self.records(:mp => mp).avg(:score)
    end
  end
  
  def passing(mp = CURRENT_MARKING_PERIOD) # Generates a list of all courses a student is passing.
    return Record.all(:student_id => self.id, :score.gte => PASSING_GRADE, :mp => mp)
  end
  
  def failing?(mp = CURRENT_MARKING_PERIOD) # Are they failing anything?
    Record.all(:student_id => self.id, :score.lt => PASSING_GRADE, :mp => mp).empty? ? false : true
  end
  
  # Is the student elibile for the Outstanding Scholar award?
  # This requires that they have an 85 or above in all classes.
  
  def outstanding?(mp = CURRENT_MARKING_PERIOD)
    total_records = self.records(:mp => mp)
    outstanding_records = self.records(:score.gte => OUTSTANDING_GRADE, :mp => mp)
    total_records == outstanding_records # Generates true if the total number of records is the same as the total records with a score above 85.
  end
  
  def iep?
    self.iep == 1
  end
  
  def ms?
    self.grade <= 8
  end
  
  def hs?
    self.grade >= 9
  end

  def psat(subject = :both)
    return nil if self.exams(:type => [6,7]).empty?

    ela = self.exams(:type => 6).max(:score)
    math = self.exams(:type => 7).max(:score)

    return ela if subject == :ela
    return math if subject == :math
    return [ela, math] if subject == both

    raise ArgumentError
  end
  
  def college_ready?(subject = :both)
    return nil if self.exams(:type => [6,7]).empty?

    if subject == :math
        self.psat(:math) >= 480 || self.math >= 80
    elsif subject == :ela
      self.psat(:ela) >= 480 || self.ela >= 75
    else
      !!(self.college_ready?(:math) && self.college_ready?(:ela))
    end
  rescue
    return nil
  end

  def college_ready(subject = :both)
    return nil if self.college_ready?(subject).nil?
    self.college_ready?(subject) ? "Yes" : "No"
  end

  def why_not_college_ready
    return "Both" if !self.college_ready?(:ela) && !self.college_ready?(:math)
    return "English" if !self.college_ready?(:ela)
    return "Math" if !self.college_ready?(:math)
  rescue
    nil
  end

  def test_score(type = nil)
    raise ArgumentError, "Missing exam type" if type.nil?
    exam = self.exams(:type => type)
    unless exam.empty? || exam.first.adjusted_score == 0
      return exam.first.adjusted_score
    end
  rescue
    return nil
  end
  
  def exam_score(type)
  	exams.all(:type => type, :order => [:year.desc, :mp.desc]).first.score
  rescue
  	nil
  end
  
  def ela
    grade < 9 ? exam_score(0) : exam_score(10)
  end
  
  def math
    grade < 9 ? exam_score(1) : exam_score(13)
  end
  
  def score(type, subject, mp = CURRENT_MARKING_PERIOD)
    courses = self.records(:course => {:subject => subject}, :mp => mp)
    course = courses.first unless courses.empty?
    course[type] unless course.nil?
  end
  
  def scores(mp = CURRENT_MARKING_PERIOD)
    scores = Hash.new
    SUBJECTS.each do |subject|
      scores[subject] = {
        :exam => self.score(:exam, subject),
        :score => self.score(:score, subject)
      }
    end
    return scores
  end
  
  def math_benchmark(mp = CURRENT_MARKING_PERIOD)
    benchmarks = self.records(:course => {:subject => "Mathematics"}, :mp => mp)
    return nil if benchmarks.empty?
    return benchmarks.first.exam.to_i
  end
  
  def movement(subject = :all, type = :score, mp1 = CURRENT_MARKING_PERIOD, mp2 = CURRENT_MARKING_PERIOD - 1)
    subject == :all ? records = self.records : records = self.records.subject(subject)
    minuend = records.mp(mp1).delete_if {|record| record[type].nil? }
    subtrahend = records.mp(mp2).delete_if {|record| record[type].nil? }
    return nil if minuend.empty? || subtrahend.empty? || minuend.first.nil? || subtrahend.first.nil?
    return minuend.avg(type).to_i - subtrahend.avg(type).to_i
  rescue
    return nil
  end
  
  def teachers
    courses.map{|course| course.teacher}.uniq.sort
  end
end
