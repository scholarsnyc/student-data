class Student
  include DataMapper::Resource

  property :id,                 Integer, :key => true
  property :active,             Boolean, :default => true
  property :firstname,          String
  property :lastname,           String
  property :grade,              Integer 
  property :previous_grade,     Integer
  property :homeroom,           Integer
  property :previous_homeroom,  Integer
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
  has n, :notes
  has n, :courses, :through => :records
  
  before :save do
    self.cohort = self.determine_cohort
    self.active = false if self.grade.nil?
  end
  
  before :update do
    self.updated_at = Time.now
  end

  # Query Methods

  def self.active(boolean = true)
    all(active: boolean)
  end
  
  def self.middleschool
    all(:grade.gte => 6, :grade.lte => 8)
  end
  
  def self.highschool
    all(:grade.gte => 9, :grade.lte => 12)
  end
  
  def self.outstanding
    all.records.current.outstanding.students - all.records.current.not_outstanding.students
  end
  
  def self.in_good_standing
    all.records.current.students - on_probation
  end
  
  def self.on_probation
    all.records.current.probationary.students
  end
  
  def self.on_level_1_probation
    all.records.current.probation_level(1).students - on_level_2_probation - failing
  end
  
  def self.on_level_2_probation
    all.records.current.probation_level(2).students - failing
  end
  
  def self.ineligible
    all.records.current.ineligible.students
  end
  
  def self.failing
    all.records.current.failing.students
  end
  
  # Descriptive Class Methods
  
  def self.ids
    all.map {|s| s.id.to_s }.uniq
  end  
  
  # Instance Methods
  
  def name
    firstname + " " + lastname
  end
  
  def probation_report
    OpenStruct.new(outstanding: records.current.outstanding,
                   good_standing: records.current.good_standing,
                   level_1: records.current.probation_level(1),
                   level_2: records.current.probation_level(2),
                   failing: records.current.failing)
  end
  
  def probation_status
    if probation_report.failing.count > 0
      3
    elsif probation_report.level_2.count > 0
      2
    elsif probation_report.level_1.count > 0
      1
    else
      nil
    end
  end
  
  def good_standing?
    !probation_status
  end
  
  def on_probation?
    !good_standing?
  end
  
  def failing?
    probation_status == 3
  end
  
  def in_middleschool?
    grade >= 6 && grade <= 8
  end
  
  def in_highschool?
    grade >= 9 && grade <= 12
  end
  
  def english_score
    scores = exams(type: [0,10], order: [ :year.desc ])
    scores.empty? ? nil : scores.first.score.rounded
  end
  
  def math_score
    scores = exams(type: [1,13], order: [ :year.desc ])
    scores.empty? ? nil : scores.first.score.rounded
  end
  
  def determine_cohort
    if homeroom =~ /\d{2}[123]/
      return :A
    elsif homeroom =~ /\d{2}[456]/
      return :B
    elsif homeroom =~ /\d{2}[78]/
      return :C
    else
      return nil
    end
  end

end