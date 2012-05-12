get '/api/students' do
  Student.all(params).to_json
end

get '/api/courses' do
  Course.all(params).to_json
end

get '/api/exams' do
  Exam.all(params).to_json
end

get '/api/course/by/id/:id' do
  Course.all(:course_id => params[:id]).to_json
end

get '/api/teacher/:teacher' do
  courses = Course.teacher(params[:teacher])
  raise NameError, "No records for #{params[:teacher]}. Make sure the first letter is capitalized." if courses.empty?
  output = {
    :teacher => params[:teacher],
    :courses => courses,
    :students => courses.students
  }.to_json
end

get '/api/student/:id' do
  student = Student.get(params[:id])
  
  {
    :name => student.name,
    :firstname => student.firstname, 
    :lastname => student.lastname, 
    :id => student.id,
    :ela => student.ela,
    :math => student.math,
    :teachers => student.teachers,
    :courses => student.courses
  }.to_json
end

get '/api/grade/:grade/lowest-third' do
  students = Student.grade(params[:grade])
  
  {
    
  }
end

get '/api/lowest-third/ela' do
  students = Student.lowest_third_ela
  all_students = Student.middleschool
  
  grades = {
    :six => 6,
    :seven => 7,
    :eight => 8
  }
  
  data = {
    :ids => students.map { |s| s.id },
    :totalCount => students.count,
    :perGrade => {}
  }
  
  grades.each do |k, g|
    data[:perGrade][k] = {
      :count => students.grade(g).count,
      :wholeGradeCount => all_students.grade(g).count,
      :notInLowestThirdCount => all_students.grade(g).count - students.grade(g).count,
      :average => students.grade(g).exams.state.ela.avg(:score),
      :wholeGradeAverage => all_students.grade(g).exams.state.ela.avg(:score)
    }
  end
  
  data.to_json
end

get '/api/lowest-third' do
  lowest_third = LowestThirdAPI.new
  lowest_third.output.to_json
end

get '/api/lowest-third/math' do
  Student.lowest_third_ela(params)
end

get '/api/trend-lines' do
  @students = Student.middleschool
  @ms_groups = [
    {:name => "Grade 6", :opts => {:grade => 6}},
    {:name => "Grade 6A", :opts => {:grade => 6, :cohort => :A}},
    {:name => "Grade 6B", :opts => {:grade => 6, :cohort => :B}},
    {:name => "Grade 6C", :opts => {:grade => 6, :cohort => :C}},
    {:name => "Grade 7", :opts => {:grade => 7}},
    {:name => "Grade 7A", :opts => {:grade => 7, :cohort => :A}},
    {:name => "Grade 7B", :opts => {:grade => 7, :cohort => :B}},
    {:name => "Grade 8", :opts => {:grade => 8}},
    {:name => "Grade 8A", :opts => {:grade => 8, :cohort => :A}},
    {:name => "Grade 8B", :opts => {:grade => 8, :cohort => :B}}
  ]
  
  @data = [:ela, :socialstudies, :math, :science, :spanish].map do |s|
    {
      Conversions::Courses::COURSES[s] => @ms_groups.map do |g|
        c = ComprehensiveReport.new(@students.all(g[:opts]), s)
        le = ComprehensiveReport.new(@students.lowest_third_ela.all(g[:opts]), s)
        lm = ComprehensiveReport.new(@students.lowest_third_math.all(g[:opts]), s)
        {
          :grade => g[:name],
          :wholeCLass => {
            :exams => {           
              :ela => c.exam_average(:state, :subject => :ela).round,
              :math =>c.exam_average(:state, :subject => :math).round
            },
            :benchmarks => [ 
              c.average(:exam, :mp => 1).round,
              c.average(:exam, :mp => 2).round,
              c.average(:exam, :mp => 3).round,
              c.average(:exam, :mp => 4).round,
              c.average(:exam, :mp => 5).round,
              c.average(:exam, :mp => 6).round
            ]
          }
        }
      end
    }
  end
  
  @data.to_json
end