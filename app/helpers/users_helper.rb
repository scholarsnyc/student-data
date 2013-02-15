# Helper methods defined here can be accessed in any controller or view in the application

StudentDatabase.helpers do
  StudentDatabase.helpers do

  def current_account
    if Padrino.env == :development
      User.get(1)
    else
      User.get(session[:user_id]) if session[:user_id]
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
    #403 unless current_account.has_access?
    redirect 'users/not_authorized' unless current_account.has_access?
  end

  def admin_only
    redirect '/' unless user_is_admin
  end
  
end
end
