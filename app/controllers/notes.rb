StudentDatabase.controllers :notes do
  
  get :index, provides: [:html, :json] do
    @notes = Note.all
    case content_type
      when :html then render 'notes/index'
      when :json then return @notes.to_json
    end
  end

  get :show, with: :id, provides: [:html, :json] do
    @note = Note.get(params[:id])
    case content_type
      when :html then render 'notes/show'
      when :json then return @note.to_json
    end
  end
  
  get :create, with: :student_id do
    @student = Student.get(params[:student_id])
    render 'notes/create'
  end
  
  post :create do
    @note = Note.create(params[:note]).inspect
  end
  
end
