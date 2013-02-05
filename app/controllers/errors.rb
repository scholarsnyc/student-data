StudentDatabase.controllers :errors do
  
  not_found do
    "These are not the droids you are looking for."
  end

  error 500 do
    "Steve screwed something up."
  end
  
end
