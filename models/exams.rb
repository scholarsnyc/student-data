class Exam
  include DataMapper::Resource
  include DataModel::Attributes

  property :id,				Serial
  property :score,		Float
  property :type,			Integer
  property :comment,	String
  property :mp,				Integer
  property :year,			Integer
  property :import,             Integer, :default => Time.now.to_i
	property :created_at,         DateTime, :default => Time.now
	property :updated_at,         DateTime, :default => Time.now

  belongs_to :student
  
  before :save do
    self.score = self.score * 100/4.5 if self.score < 5
  end
  
  before :update do
	  self.updated_at = Time.now
  end

  def self.valid_subject?(subject)
    [:math, :ela].include? subject
  end

  def self.filter(options = {})
    exams = all

    exams = exams.grade(options[:grade]) if options[:grade]
    exams = exams.cohort(options[:cohort]) if options[:cohort]
    exams = exams.all(:type => [0, 2, 4, 6]) if options[:subject] == :ela || options[:subject] == :english || options[:subject] == :ela
    exams = exams.all(:type => [1, 3, 5, 7]) if options[:subject] == :math || options[:subject] == :math
    exams = exams.all(:type => [0, 1]) if options[:type] == :state
    exams = exams.all(:type => [2, 3]) if options[:type] == :predictive
    exams = exams.all(:type => [4, 5]) if options[:type] == :acuity
    exams = exams.all(:type => [6, 7]) if options[:type] == :psat

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

  def self.psat
    all.filter(:type => :psat)
  end

  def self.ela
    all.filter(:subject => :ela)
  end

  def self.math
    all.filter(:subject => :math)
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
