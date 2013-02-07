StudentDatabase.controllers :imports do
  
  get :records do
    @imports = Record.all.map {|r| r.import }.uniq
    @imports.to_json
  end

  get :courses do
    @imports = Course.all.map {|r| r.import }.uniq
    @imports.to_json
  end

end
