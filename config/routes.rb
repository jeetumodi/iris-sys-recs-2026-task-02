require 'prometheus/client/formats/text'

Rails.application.routes.draw do
  resources :posts
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  get '/metrics', to: proc {
    [
      200,
      { 'Content-Type' => Prometheus::Client::Formats::Text::CONTENT_TYPE },
      [Prometheus::Client::Formats::Text.marshal(PROMETHEUS)]
    ]
  }
  root "posts#index"
end
