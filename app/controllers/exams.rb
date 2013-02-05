StudentDatabase.controllers :exams do
  
  before { protect_page }

  get :index, provides: [:html, :json] do
    @exams = Exam.all
    case content_type
      when :html then render 'exams/index'
      when :json then return @exams.to_json
    end
  end

  get :unique, provides: [:json] do
    @exams = Exam.all.map { |e| e.comment }.uniq
    @exams.to_json
  end
  
end