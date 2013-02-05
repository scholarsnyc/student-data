StudentDatabase.controllers :users do

  get :index, provides: [:html, :json] do
    admin_only
    @users = User.all(params)
    render 'users/index'
  end

  get :signin, do
    if user_has_access
      redirect '/'
    else
      redirect '/auth/google'
    end
  end
  
  get :signout do
    session[:user_id] = nil
    redirect '/'
  end
  
  post :grant_access, :map => '/users/grant_access_to/:id' do
    admin_only
    User.get(params[:id]).update(role: "teacher")
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