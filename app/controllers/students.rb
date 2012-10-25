StudentDatabase.controllers :students do

  before do
    protect_page
    params[:active] = true unless params[:active]
  end

  get :index do
    @students = Student.all({order: [ :homeroom.asc ]}.merge(params))
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
      @students = Student.all(params).on_level_1_probation
    when "2"
      @students = Student.all(params).on_level_2_probation
    when "3"
      @students = Student.all(params).failing
    end
    render 'students/index'
  end
  
  get :show, :map => "/students/:id" do
    @student = Student.get(params[:id])
    @records = @student.records(mp: @marking_period)
    render 'students/show'
  end
  
end
