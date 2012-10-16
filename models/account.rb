class Account
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :email, String
  property :role, String
  property :uid, String
  property :provider, String
  
  def self.find_by_id(id)
    get(id) rescue nil
  end
  
  def self.create_with_omniauth(auth)
    create! do |account|
      account.provider = auth["provider"]
      account.uid      = auth["uid"]
      account.email    = auth["name"]
      account.email    = auth["user_info"]["email"] if auth["user_info"] # we get this only from FB
      account.role     = "users"
    end
  end
end
