Rails.application.routes.draw do
devise_for :users, controllers: {
  registrations: 'users/registrations'
}

root 'items#index'
devise_scope :user do
  get 'mypage' => 'users/registrations#mypage'
  get 'logout_page' => 'users/registrations#logout_page'
  get 'profile' => 'users/registrations#profile'
  post 'profile' => 'users/registrations#update'
  get 'destination' => 'users/registrations#destination'
  post 'destination' => 'users/registrations#update'
  get '/users/sign_out' => 'devise/sessions#destroy'
end

namespace :items do
  resources :searches, only: :index
end
resources :items, only: [:index, :show,:new,:create,:destroy, :edit, :update] do
  
    collection do
      get 'genre_children', defaults: { format: 'json' }
      get 'genre_grandchildren', defaults: { format: 'json' }
    end
    member do
      get 'search'
      get 'genre_children', defaults: { format: 'json' }
      get 'genre_grandchildren', defaults: { format: 'json' }
    end
  end

  resources :purchase, only: [:index,:new,:show]

  resources :items do
    resources :comments, only: :create
  end

resources :creditcards, only:[:index, :new, :create,:destroy,:show] do
  member do
    post 'pay'
  end
  collection do
    post 'delete', to: 'creditcards#delete'
  end
end

end
