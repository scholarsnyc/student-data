class Exam
  include DataMapper::Resource
  include DataModel::Attributes

  property :id,									Serial
  property :score,							Float
  property :type,								Integer
  property :comment,						String
  property :mp,									Integer
  property :year,								Integer
  property :import,             Integer, :default => Time.now.to_i
	property :created_at,         DateTime, :default => Time.now
	property :updated_at,         DateTime, :default => Time.now


	# Code Key (it sucks that I have to do this)
	#		0 - State ELA Test (Middle School)
	#		1 - State Math Test (Middle School)
	#		2 - Predictive ELA Test (Middle School)
	#		3 - Predictive Math Test (Middle School)
	#		4 - Acuity ELA Test (Middle School)
	#		5 - Acuity Math Test (Middle School)
	#   6 - PSAT English (High School)
	#		7	- PSAT Math (High School)
	#		8 - 
	#		9 - 
	# 	10 - English Regents
	# 	11 - U.S. History and Government
	# 	12 - Global History
	# 	13 - Integrated Algebra
	# 	14 - Geometry
	# 	15 - Algebra 2 / Trigonometry
	# 	16 - Living Environment
	# 	17 - Earth Science
	# 	18 - Chemistry
	# 	19 - Physics
	# 	30 - Spanish Proficiency (Grade 8)
	#		31 - Spanish Proficiency (Grade 10)
	#		32 - Spanish Proficiency (Grade 11)
	#		40 - Polish Regents and/or LOTE
	#		41 - Anything French
	#		42 - Anything Italian
	#		50 - Math A
	
  belongs_to :student
  
  before :save do
    self.score = self.score * 100/4.5 if self.score < 5
  end
  
  before :update do
	  self.updated_at = Time.now
  end

  def self.filter(options = {})
    exams = all

    exams = exams.grade(options[:grade]) if options[:grade]
    exams = exams.cohort(options[:cohort]) if options[:cohort]
    exams = exams.all(:type => [0, 2, 4, 6, 10]) if options[:subject] == :ela || options[:subject] == :english
    exams = exams.all(:type => [1, 3, 5, 7, 13, 14, 15]) if options[:subject] == :math
    exams = exams.all(:type => [16, 17, 17, 19]) if options[:subject] == :science
    exams = exams.all(:type => [11, 12, 13]) if options[:subject] == :socialstudies
    exams = exams.all(:type => [30, 31, 32]) if options[:subject] == :spanish
    exams = exams.all(:type => [0, 1]) if options[:type] == :state
    exams = exams.all(:type => [2, 3]) if options[:type] == :predictive
    exams = exams.all(:type => [4, 5]) if options[:type] == :acuity
    exams = exams.all(:type => [6, 7]) if options[:type] == :psat
    exams = exams.all(:type => (10...20).to_a) if options[:type] == :regents

    return exams
  end

  def self.state
    all.filter(:type => :state)
  end

  def self.predictive
    all.filter(:type => :predictive)
  end

  def self.acuity
    all.filter(:type => :acuity)
  end
  
  def self.regents
  	all.filter(:type => :regents)
  end

  def self.psat
    all.filter(:type => :psat)
  end

  def self.ela
    all.filter(:subject => :ela)
  end

  def self.math
    all.filter(:subject => :math)
  end
  
  def self.science
    all.filter(:subject => :science)
  end
  
  def self.socialstudies
    all.filter(:subject => :socialstudies)
  end
  
  def self.spanish
    all.filter(:subject => :spanish)
  end

  def self.compare(subject, grade, cohort, options = {})
    exams = all.grade(grade).cohort(cohort).filter(:subject => subject)

    adjusted = true unless options[:adjusted] == false
    rounded = true unless options[:rounded] == false

    state = exams.state.avg(:score)
    predictive = exams.predictive.avg(:score)

    delta = predictive - state

    return sprintf("%.2f", delta).to_f if rounded
    return delta
  end

  def self.years
    all.sorted.map{|exam| exam.year}.uniq
  end
  
  def self.year(year)
    all(:year => year)
  end

  def self.mps
    all.sorted.map{|exam| exam.mp}.uniq
  end

  def self.most_recent(type)
    type = ExamInfo::NUMBERS if type is_a? Symbol
    most_recent = all(:order => type.desc).first[type]
    return all(type.gte => 0) if most_recent.nil?
    return all(type => most_recent)
  end

  def self.sorted
    all(:order => [ :year.desc, :mp.desc, :type.asc ])
  end

  def self.grade(grade)
    all(:student => {:grade => grade})
  end

  def self.cohort(cohort)
    all(:student => {:cohort => cohort.upcase})
  end
  
  def self.comments
  	all.map {|e| e.comment}.uniq
  end

  def adjusted_score
    if @score < 5
      Examination.adjust @score
    else
      @score
    end
  end

  def type_to_sym
    Conversions::Examinations::SYMBOLS[@type]
  end

  def type_to_s
    Conversions::Examinations::STRING[@type]
  end
end
