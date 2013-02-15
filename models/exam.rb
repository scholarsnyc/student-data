class Exam
  include DataMapper::Resource

  property :id,                 Serial
  property :score,              Float
  property :type,               Integer
  property :comment,            String
  property :mp,                 Integer
  property :year,               Integer
  property :import,             Integer, :default => Time.now.to_i, lazy: [ :meta ]
  property :created_at,         DateTime, :default => Time.now, lazy: [ :meta ]
  property :updated_at,         DateTime, :default => Time.now, lazy: [ :meta ]


  # Code Key (it sucks that I have to do this)
  #    0 - State ELA Test (Middle School)
  #    1 - State Math Test (Middle School)
  #    2 - Predictive ELA Test (Middle School)
  #    3 - Predictive Math Test (Middle School)
  #    4 - Acuity ELA Test (Middle School)
  #    5 - Acuity Math Test (Middle School)
  #    6 - PSAT English (High School)
  #    7 - PSAT Math (High School)
  #    8 - 
  #    9 - 
  #   10 - English Regents
  #   11 - U.S. History and Government
  #   12 - Global History
  #   13 - Integrated Algebra
  #   14 - Geometry
  #   15 - Algebra 2 / Trigonometry
  #   16 - Living Environment
  #   17 - Earth Science
  #   18 - Chemistry
  #   19 - Physics
  #   30 - Spanish Proficiency (Grade 8)
  #   31 - Spanish Proficiency (Grade 10)
  #   32 - Spanish Proficiency (Grade 11)
  #   40 - Polish Regents and/or LOTE
  #   41 - Anything French
  #   42 - Anything Italian
  #   50 - Math A
  
  belongs_to :student
  
  before :save do
    self.score = self.score * 100/4.5 if self.score < 5
  end
  
  before :update do
    self.updated_at = Time.now
  end

  # Factory Methods
  
  def self.create_with_data(s, score, type, year, mp, comment)
    student = Student.get(s)
    if student.nil?
      logger.warn "Student #{s} does not exist."
      return nil
    end
    Exam.create(
      score: score,
      type: type,
      year: year,
      mp: mp,
      comment: comment,
      student_id: student.id
    )
  end

  def self.create_for_ela(s, score)
    self.create_with_data(s, score, 0, 2012, 5, "State ELA Exam (Spring 2012)")
  end

  def self.create_for_math(s, score)
    self.create_with_data(s, score, 1, 2012, 5, "State Mathematics Exam (Spring 2012)")
  end
  
  # Query Methods
  
  def self.state
    all(type: [0,1])
  end
  
  def self.predictive
    all(type: [2,3])
  end
  
  def self.acuity
    all(type: [4,5])
  end
  
  def self.psat
    all(type: [6,7])
  end
  
  def self.regents
    all(type: 10..20)
  end
  
  def self.foreign_language
    all(type: 30..42)
  end
  
  def self.english
    all(type: [0,2,4,6,10])
  end
  
  def self.math
    all(type: [1,3,4,5,13,14,15])
  end
  
  def self.science
    all(type: [16,17,18,19])
  end
  
  def self.social_studies
    all(type: [11,12])
  end
  
  def self.sorted
    all(:order => [ :year.desc, :mp.desc, :type.asc ])
  end
  
  # Instance Methods
  
  def adjusted_score
    if @score < 5
      Examination.adjust @score
    else
      @score
    end
  end
  
end
