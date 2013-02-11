class Record
  include DataMapper::Resource

  property :id,           String, :key => true
  property :score,        Integer
  property :exam,         Integer, :required => false
  property :conduct,      String, :required => false
  property :course_id,    String
  property :section,      Integer
  property :mp,           Integer
  property :year,         Integer
  property :import,       Integer, :default => Time.now.to_i
  property :created_at,   DateTime, :default => Time.now
  property :updated_at,   DateTime, :default => Time.now
  
  belongs_to :student
  belongs_to :course  
  
  before :save do
    # Remove benchmark grades of zero
    exam = nil if exam == 0
  end
  
  before :update do
    self.updated_at = Time.now
  end
  
  # Constants
  
  PASSING_GRADE = 65
  AT_RISK_LEVEL_1 = 75
  AT_RISK_LEVEL_2 = 70
  OUTSTANDING_GRADE = 80
  
  # Query Methods
  
  def self.outstanding
    all(:score.gte => OUTSTANDING_GRADE)
  end
  
  def self.not_outstanding
    all(:score.lt => OUTSTANDING_GRADE)
  end
  
  def self.good_standing
    all(:score.gte => AT_RISK_LEVEL_1)
  end
  
  def self.passing
    all(:score.gte => PASSING_GRADE)
  end
  
  def self.probationary
    all(:score.lt => AT_RISK_LEVEL_1)
  end
  
  def self.probation_level(level)
    case level
    when 1
      all(:score.lt => AT_RISK_LEVEL_1, :score.gte => AT_RISK_LEVEL_2)
    when 2
      all(:score.lt => AT_RISK_LEVEL_2, :score.gte => PASSING_GRADE)
    when 3
      all(:score.lt => PASSING_GRADE)
    else
      raise ArgumentError, "Must provide probation level: 1, 2, or 3"
    end
  end
  
  def self.ineligible
    all(:score.lt => AT_RISK_LEVEL_2)
  end
  
  def self.failing
    probation_level(3)
  end
  
  def self.percent(type)
    (all.method(type).call.count * 1.0 / all.count * 100).to_rounded_percent
  end
  
  def self.current
    all(year: most_recent_year, mp: most_recent_marking_period)
  end
  
  def self.this_year
    all(year: most_recent_year)
  end

  def self.top_third(metric = :exam)
    if all.avg(:exam).zero? && metric == :exam
      metric = :score
    end
    all(:order => [ metric.desc ]).first(all.count / 3)
  end

  def self.bottom_third(metric = :exam)
    if all.avg(:exam).zero? && metric == :exam
      metric = :score
    end
    all(:order => [ metric.asc ]).first(all.count / 3)
  end
  
  # Descriptive Class Methods
  
  def self.most_recent_year
    all(order: [ :year.desc ]).first.year
  end
  
  def self.most_recent_marking_period
    all(year: most_recent_year, order: [ :mp.desc ]).first.mp
  end
  
  def self.subjects
    all.map { |r| r.course.subject }.uniq.compact
  end

  def self.years
    all.map { |r| r.year }.uniq.compact.sort
  end

  def self.active_mps
    all.map { |r| {mp: r.mp, year: r.year} }.uniq
  end
  
  # Instance Methods
    
  def outstanding?
    score >= OUTSTANDING_GRADE unless score.nil?
  end
    
  def passing?
    score >= PASSING_GRADE unless score.nil?
  end
  
  def failing?
    score < PASSING_GRADE unless score.nil?
  end
  
  def difference
    score - exam if score && exam
  end
  
  def previous
    Record.all(
      course: self.course,
      student_id: self.student_id,
      year: self.year,
      mp: self.mp - 1
    ).first
  end
  
  def next
    Record.all(
      course: self.course,
      student_id: self.student_id,
      year: self.year,
      mp: self.mp + 1
    ).first
  end

end
