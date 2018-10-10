Rails.application.routes.draw do
  devise_for :users

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  authenticated :user do
    root 'home#index'
  end
  root 'no_auth_home#index'

  resources :users, only: %i(index)
end
