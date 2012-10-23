StudentDatabase.controllers :reports do

  get :middle_school_exams do
    @reports = MiddleSchoolExamCollection.new
    return 'reports/ms_breakdown'
  end
  
end