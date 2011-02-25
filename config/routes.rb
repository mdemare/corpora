Corpora::Application.routes.draw do
  match 'lex/:source/3gram/:id', controller: 'threegram', action: 'g3', as: 'g3'
  match 'lex/:source/3gram-search/:q', controller: 'threegram', action: 'search', as: 'g3search'
  match 'lex/:source/json/token/:id', controller: 'token', action: 'json_token'
  match 'lex/:source/json/bigram/:distance', controller: 'token', action: 'json_bigram'
  match 'lex/:source/json/trigram/', controller: 'token', action: 'json_trigram'
  match 'lex/:source(/:id)', controller: 'token', action: 'token', as: 'token'
end
