class Account
  include DataMapper::Resource

  property :uid, String, :key => true
  property :name, String
  property :role, String, :default => "teacher"
  property :provider, String, :default => "google"
  property :created_at, DateTime, :default => Time.now
  
end
