StudentDatabase.controllers :reports do

  get :middle_school_exams, :map => '/reports/ms' do
    Student.all.to_json
  end

end
