class StudentDatabase < Padrino::Application
  register OmniauthInitializer
  register ScssInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl

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

  get :profile do
    content_type :text
    session[:user_id]
  end

  get :auth, :map => '/auth/:provider/callback' do
    auth = request.env["omniauth.auth"]
    user = Account.first_or_create(auth["uid"], {
      :uid => auth["uid"],
<<<<<<< HEAD
      :email => auth["info"]["nickname"],
      :role => "teacher",
=======
>>>>>>> c8f544f7ce29e079dc5ad63deaf5af5cde9e68b0
      :name => auth["info"]["name"],
      :role => "teacher"
    })
    session[:user_id] = user.uid
    session[:user_name] = user.name
    redirect '/students'
  end
end
