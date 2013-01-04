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

  get :weights do
    @courses = Course.all(order: [ :code.asc ])
    render 'courses/index-weights'
  end
  
  post :weight, map: "/courses/:course/weight/:weight", provides: :json  do 
    @course = Course.get(params[:course])
    @course.update(weight: params[:weight])
    render json: {course: @course, success: true}
  end
  
end
