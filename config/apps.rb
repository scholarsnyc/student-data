Padrino.configure_apps do
  # enable :sessions
  set :session_secret, '5898819f1f77b6c9c7f588247af7d4ed3979eb949fe996faaabda3fcbaa86a8c'
end

# Mounts the core application for this project
Padrino.mount("StudentDatabase").to('/')
