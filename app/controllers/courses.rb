StudentDatabase.controllers :courses do
  
  before do
    protect_page
  end
  
  get :index do
    @courses = Course.all(params).all(order: [ :code.asc ], year: CURRENT_YEAR)
    render 'courses/index'
  end
  
  get :show, :map => "/courses/:id" do
    @course = Course.get(params[:id])
    @records = @course.records(mp: @marking_period, year: @year)
    render 'courses/show'
  end
  
  post :weight, map: "/course/:course/weight/:weight", provides: :json  do 
    @course = Course.get(params[:course])
    @course.update(weight: params[:weight])
    return {course: @course, success: true}
  end
  
end
