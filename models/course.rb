class Course
  include DataMapper::Resource

  property :code,       String, :key => true
  property :name,       String
  property :teacher,    String
  property :course_id,  String
  property :section,    Integer
  property :subject,    String
  property :year,       Integer, :default => CURRENT_YEAR
  property :import,     Integer, :default => Time.now.to_i
  property :created_at, DateTime, :default => Time.now
  property :updated_at, DateTime, :default => Time.now
  property :weight,     Float, :default => 1.0
  
  before :save do
    self.code = "#{course_id}#{section}#{year}"
  end
  
  before :update do
    self.updated_at = Time.now
  end
  
  has n, :records
  has n, :students, :through => :records
  
  def self.codes
    all.map {|c| c.code }
  end
  
  def set_code
    @code = "#{course_id}#{section}#{year}"
    self
  end

end
