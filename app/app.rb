class StudentDatabase < Padrino::Application
  register OmniauthInitializer
  register ScssInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl

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
    auth    = request.env["omniauth.auth"]
    account = Account.find_by_provider_and_uid(auth["provider"], auth["uid"]) || 
              Account.create_with_omniauth(auth)
    set_current_account(account)
    redirect "http://" + request.env["HTTP_HOST"] + url(:student)
  end
end
