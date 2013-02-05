StudentDatabase.controllers :courses, conditions: { protect: true } do
  
  extend Protections

  get :index, provides: [:html, :json] do
    @courses = Course.all(order: [ :code.asc ], year: @year)
    case content_type
      when :html then render 'courses/index'
      when :json then return @courses.to_json
    end
  end
  
  get :show, with: :id, provides: [:html, :json] do
    @course = Course.get(params[:id])
    @records = @course.records(mp: @marking_period, year: @year)
    case content_type
      when :html then render 'courses/show'
      when :json then return {course: @course, students: @course.students}.to_json
    end
  end
  
end