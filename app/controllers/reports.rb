StudentDatabase.controllers :reports do

  get :middle_school_exams, :map =>  do
    @reports = MiddleSchoolExamCollection.new
    return 'reports/ms_breakdown'
  end
  
end