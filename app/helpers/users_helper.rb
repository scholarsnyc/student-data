# Helper methods defined here can be accessed in any controller or view in the application

StudentDatabase.helpers do
  
  def current_account
    if session[:user_id]
      User.get(session[:user_id])
    end
  end
  
end
