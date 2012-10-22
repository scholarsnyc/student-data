class StudentDatabase < Padrino::Application
  register OmniauthInitializer
  register ScssInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  Padrino.use OmniAuth::Builder do
    provider :developer unless Padrino.env == :production
    provider :google, 'scholarsnyc.com', 'gbSiQxRCLg41RgQCTK4rOV+a'
  end

  enable :sessions
  
  before do
    @marking_period = params[:mp] || 6
  end
  
  get :index do
    haml <<-HAML.gsub(/^ {6}/, '')
      Login with
      =link_to('Google', '/auth/google')
    HAML
  end

end
