StudentDatabase.controllers :reports do

  get :middle_school_exams do
    @reports = Reports::MiddleSchoolExamCollection.new
    render 'reports/ms_breakdown'
  end  
  
end
