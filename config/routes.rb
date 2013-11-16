NewPoolcOgameServer::Application.routes.draw do
  resources :planets

  root :to => 'planets#index'

  get 'reports/parse' => 'reports#parse'
  post 'reports/do_parse' => 'reports#do_parse'
end
