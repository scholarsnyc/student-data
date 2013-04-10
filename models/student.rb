class Student
  include DataMapper::Resource

  property :id,                 Integer, :key => true
  property :active,             Boolean, :default => true
  property :firstname,          String
  property :lastname,           String
  property :grade,              Integer 
  property :previous_grade,     Integer, lazy: [ :past ]
  property :homeroom,           Integer, lazy: [ :demographic ]
  property :previous_homeroom,  Integer, lazy: [ :past ]
  property :cohort,             String
  property :previous_cohort,    String, lazy: [ :past ]
  property :gender,             Integer, lazy: [ :demographic ]
  property :ethnicity,          Integer, lazy: [ :demographic ]
  property :language,           String, lazy: [ :demographic ]
  property :iep,                Integer, lazy: [ :demographic ]
  property :math,               Integer, lazy: [ :test ]
  property :ela,                Integer, lazy: [ :test ]
  property :lowest_third_ela,   Boolean, :default => false
  property :lowest_third_math,  Boolean, :default => false
  property :aat,                Boolean, :default => false
  property :import,             Integer, :default => Time.now.to_i, lazy: [ :meta ]
  property :created_at,         DateTime, :default => Time.now, lazy: [ :meta ]
  property :updated_at,         DateTime, :default => Time.now, lazy: [ :meta ]
  
  has n, :records
  has n, :exams
  has n, :notes
  has n, :courses, :through => :records
  
  before :save do
    self.cohort = self.determine_cohort
    self.active = false if self.grade.nil?
    self.ela = self.english_score
    self.math = self.math_score
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

  def self.lowest_third_ela
    all(lowest_third_ela: true)
  end

  def self.lowest_third_math
    all(lowest_third_math: true)
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
  
  def self.eligible_for_honor_society
    all(order: [:grade.asc, :homeroom.asc, :lastname.asc]).keep_if { |s| s.eligible_for_honor_society? }
  end
  
  # Descriptive Class Methods
  
  def self.ids
    all.map {|s| s.id.to_s }.uniq
  end  

  def self.names
    all.map {|s| s.name }.uniq
  end

  def self.grades
    all.map {|s| s.grade}.uniq.sort
  end

  # Instance Methods
  
  def name
    firstname + " " + lastname
  end
  
  def probation_report
    OpenStruct.new(outstanding: records.current.outstanding,
                   good_standing: records.current.good_standing,
                   probationary: records.current.probationary,
                   level_1: records.current.probation_level(1),
                   level_2: records.current.probation_level(2),
                   failing: records.current.failing)
  end
  
  def probation_subjects(level = probation_status)
    p = probation_report
    case level
      when 1 then p.level_1.subjects.to_s.gsub(/[\[\]"]/, '')
      when 2 then p.level_2.subjects.to_s.gsub(/[\[\]"]/, '')
      when 3 then p.failing.subjects.to_s.gsub(/[\[\]"]/, '')
      when :all then p.probationary.subjects.to_s.gsub(/[\[\]"]/, '')
    end
  end
    
  def probation_status
    if probation_report.failing.count > 0
      3
    elsif probation_report.level_2.count > 0
      2
    elsif probation_report.level_1.count > 0
      1
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
  
  def eligible_for_honor_society?
    eligible = true
    records.years.each do |year|
      if records(year: year).avg(:score) < 90
        eligible = false
      end
    end
    return eligible
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

  def update_scores
    self.ela = self.english_score
    self.math = self.math_score
    self.save
  end

end