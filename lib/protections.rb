module Protections
  def self.protect(*args)
    condition do
      unless User.get(session[:user_id]).has_access?
        halt 403, "No secrets for you!"
      end
    end
  end
end