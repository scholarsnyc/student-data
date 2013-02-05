StudentDatabase.controllers :reports, conditions: { protect: true } do

  extend Protections

  def self.protect(*args)
    condition do
      unless user_has_access
        halt 403, "No secrets for you!"
      end
    end
  end

  get :middle_school_exams do
    @reports = Reports::MiddleSchoolExamCollection.new
    render 'reports/ms_breakdown'
  end  
  
end