# Helper methods defined here can be accessed in any controller or view in the application

StudentDatabase.helpers do
  
  def student_query_params
    params.dup.keep_if { |key, value| Student.properties.map { |p| p.name }.include?(key) }
  end
  
end