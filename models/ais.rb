class AISClass
	include DataMapper::Resource

	property :id,									Serial, :key => true
	property :name,								String
	property :teacher,						String
	property :subject,						String
	property :student_list,				Json
	property :import,             Integer, :default => Time.now.to_i
	property :created_at,         DateTime, :default => Time.now
	property :updated_at,         DateTime, :default => Time.now

	before :update do
	  self.updated_at = Time.now
  end
  
  def students
  	student_list.map {|osis| Student.get(osis)}
  end
	
end