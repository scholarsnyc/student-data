# ========================================================================================
# Courses
# ========================================================================================

get '/courses' do
  # Takes the marking period out of the paramaters because it's not actually part of the model.
  params.delete("mp")
  
  @courses = Course.all(params)
  @title = "Courses"
  if params[:teacher] && params[:subject]
    @title = @title + ": " +  params[:teacher] + ", " + params[:subject]
  elsif params[:teacher]
    @title = @title + ": " +  params[:teacher]
  elsif params[:subject]
    @title = @title + ": " +  params[:subject]
  end
  @breakdown = CourseBreakdown.new(@courses).breakdown
		
	erb :courses_view
end

get '/courses/:code' do # Pull up all records for a course.
	@course = Course.get(params[:code])
	@title = @course.name
	@records = @course.records(:mp => @marking_period)
	@breakdown = @course.to_breakdown
  
	@records_lowest_third = Array.new
	@records_highest_third = Array.new
	
	erb :course_view
end

get '/birdseye' do
	redirection = "/courses/grade/#{params[:grade]}/subject/#{params[:subject]}"
	redirection = redirection << "?cohort=#{params[:cohort]}" if params[:cohort] =~ /^[ABC]$/
	redirect redirection
end

get '/courses/grade/:grade/subject/:subject' do
	@grade = params[:grade]
	@subject = params[:subject]
	@title = "Grade #{@grade}: #{@subject}"
	unless params[:cohort]	
		@records = Record.all(:student => {:grade => @grade}, :course => {:subject => @subject}, :mp => @marking_period)
	else
		@cohort = params[:cohort].upcase.to_sym
		@title += " (Cohort #{@cohort})"
		@records = Record.all(:student => {:grade => @grade, :cohort => @cohort}, :course => {:subject => @subject}, :mp => @marking_period)
	end
	@breakdown = @records.courses.to_breakdown
	erb :course_view
end
