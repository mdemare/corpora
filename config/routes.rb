Corpora::Application.routes.draw do
  match '3gram/:action(/:id)', :controller => 'threegram'
  match 'token/:id', :controller => 'token', :action => 'token'
end
