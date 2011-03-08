Corpora::Application.routes.draw do
  match 'lex/:source/examples/:phrase', controller: 'token', action: 'examples', as: 'examples'
  match 'lex/:source/3gram-search/:q', controller: 'threegram', action: 'search', as: 'g3search'
  match 'lex/:source/json/token/:word', controller: 'token', action: 'json_token'
  match 'lex/:source/json/bigram/:distance', controller: 'token', action: 'json_bigram'
  match 'lex/:source/json/trigram', controller: 'token', action: 'json_trigram'
  match 'lex/:source/json/examples', controller: 'token', action: 'json_examples'
  match 'lex/:source(/:id)', controller: 'token', action: 'token', as: 'token'
end
