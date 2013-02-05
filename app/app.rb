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

    if Padrino.env == :development && session[:user_id]
      session[:user_id] = User.all(email: 'kinney@scholarsnyc.com').first.id
    end
  end
  
  get :index do
    haml <<-HAML.gsub(/^ {6}/, '')
    HAML
  end

end