Rails.application.routes.draw do
  devise_for :users

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  root 'home#index'
end
