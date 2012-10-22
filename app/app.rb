class StudentDatabase < Padrino::Application
  register OmniauthInitializer
  register ScssInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions
  
  before do
    @marking_period = params[:mp] || 6
    unless session[:user_id] =~ /.*@scholarsnyc.com/
      redirect url(:signin)
    end
  end
  
  get :index do
    haml <<-HAML.gsub(/^ {6}/, '')
      %p Hello world!
    HAML
  end
  
  get :signin do
    haml <<-HAML.gsub(/^ {6}/, '')
      =link_to('Log in', '/auth/google')
    HAML
  end
  
  get :sighout do
    session[:user_id] = nil
    redirect '/'
  end

  get '/auth/:name/callback' do
    auth = request.env["omniauth.auth"]
    user = User.first_or_create({ :uid => auth["uid"]}, {
      :uid => auth["uid"],
      :name => auth["info"]["name"] })
    session[:user_id] = user.id
    redirect '/students'
  end

end
