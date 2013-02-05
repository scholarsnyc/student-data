StudentDatabase.controllers :students do

  before do
    protect_page
    params[:active] = true if params[:active].nil?
  end

  get :index, provides: [:html, :json] do
    @students = Student.all(student_query_params)
    case content_type
      when :html then render 'students/index'
      when :json then return @students.to_json
    end
  end
  
  get :middleschool, provides: [:html, :json] do
    @students = Student.middleschool
    case content_type
      when :html then render 'students/index'
      when :json then return @students.to_json
    end
  end
  
  get :highschool, provides: [:html, :json] do
    @students = Student.highschool
    case content_type
      when :html then render 'students/index'
      when :json then return @students.to_json
    end
  end
  
  get :grade, :with => :grade, provides: [:html, :json] do
    @students = Student.all(grade: params[:grade])
    case content_type
      when :html then render 'students/index'
      when :json then return @students.to_json
    end
  end
  
  get :homeroom, :with => :homeroom, provides: [:html, :json] do
    @students = Student.all(homeroom: params[:homeroom])
    case content_type
      when :html then render 'students/index'
      when :json then return @students.to_json
    end
  end
  
  get :ineligible, provides: [:html, :json] do
    @title = "Ineligible List"
    @students = Student.ineligible.all(order: [ :homeroom.asc ]).all(params)
    case content_type
      when :html then render 'students/index'
      when :json then return @students.to_json
    end
  end

  get :honors, provides: [:html, :json] do
    @title = "Students Eligible for the National Honor Society"
    @students = Student.all(grade: [7,10]).eligible_for_honor_society
    case content_type
      when :html then render 'students/index'
      when :json then return @students.to_json
    end
  end
  
  get :probation, with: :level, provides: [:html, :json] do
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
    else
      @students = Student.on_probation
      @probation_level = 3
    end
    case content_type
      when :html then render 'students/probation'
      when :json then return @students.to_json
    end
  end
  
  get :show, with: :id, provides: [:html, :json] do
    @student = Student.get(params[:id])
    @records = @student.records(mp: @marking_period, year: @year)
    @notes = @student.notes
    case content_type
      when :html then render 'students/show'
      when :json then return @student.to_json
    end
  end
  
end
