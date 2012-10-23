StudentDatabase.controllers :users do
  
  get :signin, :map => '/signin' do
    if user_has_access
      redirect '/'
    else
      redirect '/auth/google'
    end
  end
  
  get :signout, :map => '/signout' do
    session[:user_id] = nil
    redirect '/'
  end
  
  get :index do
    protect_page
    @users = User.all(params)
    render 'users/index'
  end
  
  get :not_authorized, :map => '/not_authorized' do
    render 'users/not_authorized'
  end
  
  
  get :authenticate, :map => '/auth/:name/callback' do
    auth = request.env["omniauth.auth"]
    user = User.first_or_create({ :email => auth["uid"]}, {
      :email => auth["uid"],
      :name => auth["info"]["name"] })
    session[:user_id] = user.id
    redirect '/'
  end

end
