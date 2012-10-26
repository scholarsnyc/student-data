StudentDatabase.controllers :students do

  before do
    protect_page
    params[:active] = true unless params[:active]
  end

  get :index do
    @students = Student.all(student_query_params)
    render 'students/index'
  end
  
  get :index, :provides => :json do
    @students = Student.all(student_query_params)
    render json: @students
  end
  
  get :middleschool do
    @students = Student.middleschool
    render 'students/index'
  end
  
  get :highschool do
    @students = Student.highschool
    render 'students/index'
  end
  
  get :grade, :with => :grade do
    @students = Student.all(grade: params[:grade])
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
    @notes = @student.notes
    render 'students/show'
  end
  
end
