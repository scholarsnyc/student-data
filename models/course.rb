class Course
  include DataMapper::Resource

  property :code,       String, :key => true
  property :name,       String
  property :teacher,    String
  property :course_id,  String
  property :section,    Integer
  property :subject,    String
  property :year,       Integer
  property :import,     Integer, :default => Time.now.to_i
  property :created_at, DateTime, :default => Time.now
  property :updated_at, DateTime, :default => Time.now
  
  before :update do
    self.updated_at = Time.now
  end
  
  has n, :records
  has n, :students, :through => :records

end
