class User
  include DataMapper::Resource
  
  property :id,         Serial
  property :uid,        String
  property :name,       String
  property :role,       String, :default => "teacher"
  property :created_at, DateTime, :default => Time.now
  
end