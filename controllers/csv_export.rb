get '/students.csv' do
	content_type 'text/csv', :charset => 'utf-8'
	Student.all(params).to_csv
end

get '/ineligible-students.csv' do
	content_type 'text/csv', :charset => 'utf-8'
	Student.ineligible.all(params).to_csv
end


get '/courses.csv' do
	content_type 'text/csv', :charset => 'utf-8'
	Course.all(params).to_csv
end

get '/records.csv' do
	content_type 'text/csv', :charset => 'utf-8'
	Student.all(params).to_csv
end

get '/exams.csv' do
	content_type 'text/csv', :charset => 'utf-8'
	Exam.all(params).to_csv
end