StudentDatabase.controllers :students do

  before do
    protect_page
    params[:active] = true if params[:active].nil?
  end

  get :index do
    @students = Student.all(student_query_params)
    render 'students/index'
  end
  
  get :index, :provides => :json do
    @students = Student.all.map do |s| 
      {id: s.id, name: s.name, grade: s.grade, homeroom: s.homeroom}
    end
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
  
  get :homeroom, :with => :homeroom do
    @students = Student.all(homeroom: params[:homeroom])
    render 'students/index'
  end
  
  get :ineligible do
    @title = "Ineligible List"
    @students = Student.ineligible.all(order: [ :homeroom.asc ]).all(params)
    render 'students/index'
  end

  get :honors do
    @title = "Students Eligible for the National Honor Society"
    @students = Student.all(grade: [7,10]).eligible_for_honor_society
    render 'students/index'
  end
  
  get :probation, :map => "/students/probation/:level" do
    @title = "Probation: Level #{params[:level]}"
    case params[:level]
    when "1"
      @students = Student.on_level_1_probation
      @probation_level = 1
    when "2"
      @students = Student.on_level_2_probation
      @probation_level = 2
    when "3"
      @students = Student.failing
      @probation_level = 3
    end
    render 'students/probation'
  end
  
  get :show, :map => "/students/:id" do
    @student = Student.get(params[:id])
    @records = @student.records(mp: @marking_period, year: @year)
    @notes = @student.notes
    render 'students/show'
  end
  
   get :show, :map => "/students/:id" do
    @student = Student.all
    
  end
  
end
