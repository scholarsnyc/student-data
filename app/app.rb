class StudentDatabase < Padrino::Application
  register OmniauthInitializer
  register ScssInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions
  
  before do
    @marking_period = params[:mp] || 1
    @year = params[:year] || 2013
  end
  
  get :index do
    haml <<-HAML.gsub(/^ {6}/, '')
    HAML
  end

end

module Protections
  def protect(protected)
    user = User.get(session[:user_id])
    condition do
      halt 403, "No secrets for you!" unless user && user.has_access?
    end if protected
  end
end