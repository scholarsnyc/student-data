class StudentDatabase < Padrino::Application
  register OmniauthInitializer
  register ScssInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions
  
  before do
    @marking_period = params[:mp] || 3
    @year = params[:year] || 2013
  end
  
  get :index do
    haml <<-HAML.gsub(/^ {6}/, '')
    HAML
  end

end
