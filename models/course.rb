class Course
  include DataMapper::Resource

  property :code,       String, :key => true
  property :name,       String
  property :teacher,    String
  property :course_id,  String
  property :section,    Integer
  property :subject,    String
  property :year,       Integer, :default => CURRENT_YEAR
  property :import,     Integer, :default => Time.now.to_i, lazy: [ :meta ]
  property :created_at, DateTime, :default => Time.now, lazy: [ :meta ]
  property :updated_at, DateTime, :default => Time.now, lazy: [ :meta ]
  property :weight,     Float, :default => 1.0
  
  before :save do
    self.code = "#{course_id}#{section}#{year}"
  end
  
  before :update do
    self.code = "#{course_id}#{section}#{year}"
    self.updated_at = Time.now
  end
  
  has n, :records
  has n, :students, :through => :records
  
  def self.subjects
    all.map {|c| c.subject }.uniq
  end
  
  def self.teachers
    all(order: [ :teacher.asc ]).map {|c| c.teacher }.uniq
  end
  
  def self.by_teacher
    courses_by_teacher = {}
    all.teachers.each do |teacher|
      courses_by_teacher[teacher] = all(teacher: teacher)
    end
    return courses_by_teacher
  end

  def self.codes
    all.map {|c| c.code }
  end
  
  def set_code
    @code = "#{course_id}#{section}#{year}"
    self
  end

end
