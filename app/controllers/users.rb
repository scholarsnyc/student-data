StudentDatabase.controllers :users do
  
  get :signin, :map => '/signin' do
    haml <<-HAML.gsub(/^ {6}/, '')
      =link_to('Log in', '/auth/google')
    HAML
  end
  
  get :signout, :map => '/signout' do
    session[:user_id] = nil
    redirect '/signin'
  end

end
