# ========================================================================================
# Students
# ========================================================================================

get '/students' do
	@students = Student.all(params)
	@title = "Student List"
	@notice = "<strong>Oh fudge!</strong> There is nothing to show you in this view." if @students.empty?
	erb :students_view
end

get '/students/college-readiness' do
	@students = Student.all(:exams => {:type => [6,7]})
	@title = "College Readiness"
	@notice = "<strong>Oh fudge!</strong> There is nothing to show you in this view." if @students.empty?
	erb :college_ready_view
end

get '/students/not-college-ready' do
	@students = Student.not_college_ready
	@title = "Not College Ready"
	@notice = "<strong>Oh fudge!</strong> There is nothing to show you in this view." if @students.empty?
	erb :college_ready_view
end

get '/students/exam/:type/below/:score' do
	exams = ['State ELA', 'State Math', 'ELA Acuity', 'Math Acuity', 'ELA Predictive', 'Math Predictive']

	@title = "Students with &lt; #{params[:score]} on #{exams[params[:type].to_i]} Exam"
	@students = Student.all(:exams => {:type => params[:type].to_i, :score.lt => params[:score].to_i})

	erb :students_view
end

get '/students/:id' do
	@student = Student.get(params[:id])
	@records = @student.records(:mp => @marking_period)

	@title = @student.name
	@notice = "<strong>Great Odin's Raven!</strong> There are no records for this student." if @records.empty?
	erb :student_view
end

get '/students/:id/mp/:mp' do
	@student = Student.get(params[:id])
	@records = Record.all(:student_id => params[:id], :mp => params[:mp])
	
	@title = "#{@student.name}, Marking Period #{params[:mp]}"
	@notice = "<strong>Gadzooks!</strong> There are no records for this marking period." if @records.empty?
	
	erb :student_view
end

get '/students.csv' do
	content_type 'text/csv', :charset => 'utf-8'
	Student.all(params).to_csv
end

get '/students.json' do
	Student.all(params).to_json
end