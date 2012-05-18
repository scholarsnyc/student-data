# ========================================================================================
# Reports
# ========================================================================================

get '/reports/probation-two-plus' do
	@title = "Probation: Level Two +"
 	@report = Student.failing.all(params)
 	@probation_level = 3
	
	erb :probation_view
end

get '/reports/probation-two' do
	@title = "Probation: Level Two"
 	@report = Student.probation_2.all(params)
 	@probation_level = 2
	
	erb :probation_view
end

get '/reports/probation-one' do
	@title = "Probation: Level One"
 	@report = Student.probation_1.all(params)
 	@probation_level = 1
  	
	erb :probation_view
end

get '/reports/ineligible' do
  	@title = "Ineligible List"
  	@report = Student.ineligible.all(params)
  	@probation_level = 3
  
  	erb :probation_view
end

get '/reports/breakdown/grades' do
  @title = "Grade Breakdown"
  @students = Student.all

	erb :grade_breakdown
end

get '/reports/breakdown/subject' do
	@title = "Subject Area Breakdown"
	
	probation_1 = Record.all(:score.lt => AT_RISK_GRADE, :score.gte => AT_RISK_LEVEL_2, :mp => CURRENT_MARKING_PERIOD)
	probation_2 = Record.all(:score.lt => AT_RISK_LEVEL_2, :score.gte => PASSING_GRADE, :mp => CURRENT_MARKING_PERIOD)
	failing = Record.all(:score.lt => PASSING_GRADE, :mp => CURRENT_MARKING_PERIOD)
	
	@subject_breakdown = Array.new
	
	SUBJECTS.each do |subject|
		breakdown = {
			:name => subject, 
			:probation_1 => probation_1.courses(:subject => subject).count,
			:probation_2 => probation_2.courses(:subject => subject).count,
			:failing => failing.courses(:subject => subject).count
		}
		@subject_breakdown << breakdown
	end
	
	erb :subject_breakdown
end

get '/reports/outstanding' do
  @title = "Eligible for Outstanding Scholar"
  @students = Array.new
  
  Student.all(:grade.gte => 9).each {|student| @students << student if student.outstanding?(@marking_period)}
  
  erb :students_view
end

get '/reports/lowest/by/report-card' do
	@title = "Lowest Performing Students by Report Card Grade"
	@count = params[:count] || LOWEST_COUNT
	if params[:cohort] =~ /[ABCabc]{1}/
		cohort = params[:cohort].upcase
	else
		cohort = nil
	end
	
	@reports = Array.new
	GRADES.each do |grade|
		SUBJECTS.each do |subject|
			if cohort
				lowest_performers = LowestPerformers.new(grade, subject, cohort, :score, @marking_period, @count)
			else
				lowest_performers = LowestPerformers.new(grade, subject, :all, :score, @marking_period, @count)
			end
			@reports << lowest_performers
		end
	end
	
	erb :report_lowest
end

get '/reports/lowest/by/benchmark' do
	@title = "Lowest Performing Students by Benchmark Exam"
	@count = params[:count] || LOWEST_COUNT
	if params[:cohort] =~ /[ABCabc]{1}/
		cohort = params[:cohort].upcase
	else
		cohort = nil
	end
	
	@reports = Array.new
	GRADES.each do |grade|
		SUBJECTS.each do |subject|
			if cohort
				lowest_performers = LowestPerformers.new(grade, subject, cohort, :exam, @marking_period, @count)
			else
				lowest_performers = LowestPerformers.new(grade, subject, :all, :exam, @marking_period, @count)
			end
			@reports << lowest_performers
		end
	end
	
	erb :report_lowest
end

get '/reports/lowest/third/by/nys/:type' do
	@students = Exam.all(:type => params[:type], :student => {:grade.gte => 6, :grade.lte => 8}, :order => [:score.asc], :limit => 642/3).students
	erb :students_view
end

get '/reports/lowest/third/by/nys/:type/grade/:grade' do
	# Get the state exam scores in ascending order for students in a given grade
	# TODO: There has got to be a better way to do this.
	student_count = Student.all(:grade => params[:grade]).count
	@students = Exam.all(:type => params[:type], :student => {:grade => params[:grade]}, :order => [:score.asc], :limit => student_count/3).students
	erb :students_view
end


get '/reports/breakdown/subject-teacher' do
	@title = "Subject-Teacher Breakdown"
	@subjects = Course.subjects
	
	erb :subject_teacher_breakdown
end

get '/reports/hs-math' do
	@title = "High School Students with a 79 or Below on the Math Regents"
	@students = Student.all(:exams => {:type => 1, :score.lt => 80}).highschool
	
	erb :students_view
end

get '/reports/performance-histogram' do
  @title = "Performance Histograms"
  @courses = Course.subject(["English","Mathematics","Science","Social Studies","Spanish"])
  
  erb :grade_subject_histogram
end

get '/reports/benchmark-data-by-subject-and-grade' do
  @title = "Analyze Benchmark Data by Subject and Grade"
  erb :benchmark_data_by_subject_and_grade
end