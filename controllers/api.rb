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

get '/api/cep/grade/:grade/subject/:subject' do
  grade = params[:grade]
  subject = params[:subject].to_sym
  @data = Grade.new(grade).to_comprehensive_report(subject).to_json
end