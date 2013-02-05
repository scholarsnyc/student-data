class Note
  include DataMapper::Resource

  property :id,           Serial
  property :title,        String
  property :content,      Text
  property :type,         Integer
  property :created_at,   DateTime, :default => Time.now
  property :updated_at,   DateTime, :default => Time.now
  
  belongs_to :student
  belongs_to :user
  
  before :update do
    updated_at = Time.now
  end
  
  def self.types
    TYPES
  end
  
  TYPES = {
    0 => "Anecdotal Note",
    1 => "Parent Phone Call",
    2 => "Parent Conference",
    5 => "Student Performance Conference",
    6 => "Student Goal Setting Conference",
    7 => "Student Behavior Conference",
    10 => "Disciplinary Actions",
    11 => "In-School Suspension"
  }
  
  def to_s
    TYPES[type]
  end
  
  def date
    created_at.strftime("%m/%d/%y")
  end
  
end