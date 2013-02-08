class StudentDatabase < Padrino::Application
  register OmniauthInitializer
  register ScssInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions
  
  before do
    @marking_period = params[:mp] || 4
    @year = params[:year] || 2013
  end
  
  get :index do
    if user_has_access
      @students = Student.all
      @courses = Course.all
      render('misc/home')
    else
      render('misc/visiting')
    end
  end

  error 403 do
    render("users/not_authorized")
  end

end
