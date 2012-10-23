StudentDatabase.controllers :courses do
  
  before do
    if current_account.nil? || current_account.email != "kinney@scholarsnyc.com"
      redirect :signin
    end
  end
  
  get :index do
    @courses = Course.all(params).all(order: [ :code.asc ])
    render 'courses/index'
  end
  
  get :show, :map => "/courses/:id" do
    @course = Course.get(params[:id])
    @records = @course.records(mp: @marking_period)
    render 'courses/show'
  end
  
end