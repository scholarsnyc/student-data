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
  
  set :login_page, "/" # determines the url login occurs

  access_control.roles_for :any do |role|
    role.protect "/students" # here a demo path
  end

  # now we add a role for users
  access_control.roles_for :users do |role|
    role.allow "/profile"
  end
  
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
    current_account.to_yaml
  end

  get :destroy do
    set_current_account(nil)
    redirect url(:index)
  end

  get :auth, :map => '/auth/:provider/callback' do
    auth = request.env["omniauth.auth"]
    user = Account.first_or_create({ :uid => auth["uid"]}, {
      :uid => auth["uid"],
      :email => auth["info"]["nickname"],
      :role => "teacher",
      :name => auth["info"]["name"],
      :created_at => Time.now })
    session[:user_id] = user.id
    redirect '/'
  end
end
