Corpora::Application.routes.draw do
  match 'lex/:source/3gram/:id', controller: 'threegram', action: 'g3', as: 'g3'
  match 'lex/:source/3gram-search/:q', controller: 'threegram', action: 'search', as: 'g3search'
  match 'lex/:source(/:id)', controller: 'token', action: 'token', as: 'token'
end
