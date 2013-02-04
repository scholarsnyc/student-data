StudentDatabase.controllers :notes do
  
  get :show, :map => "/notes/:id" do
    @note = Note.get(params[:id])
    render 'notes/show'
  end
  
  get :create, :map => "students/:id/notes/create" do
    @student = Student.get(params[:id])
    render 'notes/create'
  end
  
  post :create, :map => "/notes/create" do
    @note = Note.create(params[:note])
  end
  
end
