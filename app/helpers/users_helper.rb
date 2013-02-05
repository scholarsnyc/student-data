# Helper methods defined here can be accessed in any controller or view in the application

StudentDatabase.helpers do

  def current_account
    if session[:user_id]
      User.get(session[:user_id])
    end
  end
  
  def user_has_access
    !!current_account && current_account.has_access?
  end
  
  def user_is_admin
    current_account && current_account.is_admin?
  end
  
  def user_is_revoked
    current_account && current_account.is_revoked?
  end
  
  def user_is_pending
    current_account && current_account.is_pending?
  end
  
  def protect_page
    return if Padrino.env == :development
    unless current_account.has_access?
      halt 403, render("users/not_authorized")
    end
  end
  
  def admin_only
    redirect '/' unless user_is_admin
  end
  
end
