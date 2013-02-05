StudentDatabase.controllers :errors do
  
  not_found do
    "These are not the droids you're looking for."
  end

  error 500 do
    "Steve screwed something up."
  end
  
end
