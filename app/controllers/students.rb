StudentDatabase.controllers :students do

  before do
    protect_page
    params[:active] = true unless params[:active]
  end

  get :index, :provides => [:html, :json] do
    @students = Student.all(params)
    render json: @students if content_type == :json
    render 'students/index'
  end
  
  get :ineligible do
    @title = "Ineligible List"
    @students = Student.ineligible.all(order: [ :homeroom.asc ]).all(params)
    render 'students/index'
  end
  
  get :probation, :map => "/students/probation/:level" do
    @title = "Probation: Level #{params[:level]}"
    case params[:level]
    when "1"
      @students = Student.on_level_1_probation
    when "2"
      @students = Student.on_level_2_probation
    when "3"
      @students = Student.failing
    end
    render 'students/index'
  end
  
  get :show, :map => "/students/:id" do
    @student = Student.get(params[:id])
    @records = @student.records(mp: @marking_period)
    render 'students/show'
  end
  
end
