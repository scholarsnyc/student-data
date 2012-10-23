class User
  include DataMapper::Resource
  
  property :id,         Serial
  property :email,      String
  property :name,       String
  property :role,       String, :default => "teacher"
  property :created_at, DateTime, :default => Time.now
  
  def has_access?
    role == "teacher" || role == "admin"
  end
  
  def is_admin?
    role == "admin"
  end
  
  def grant_access
    update(role: "teacher") unless has_access?
  end
  
  def revoke_access
    update(role: "revoked") unless is_admin?
  end
  
  def promote_to_admin
    update(role: "admin")
  end
  
end