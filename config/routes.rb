Rails.application.routes.draw do

  get "posts", to: "posts#index"

  # Current_user actions
  get ":id", to: "current_user#index"

  # Posts actions
  post "posts", to: "posts#create"
  get "posts/:id", to: "posts#show"
  put "posts/:id", to: "posts#update"
  delete "posts/:id", to: "posts#destroy"

  # Comments actions
  get "posts/:id/comments", to: "comments#index"
  get "posts/:id/comments/:comment_id", to: "comments#show"
  post "posts/:id/comments", to: "comments#create"
  put "posts/:id/comments/:comment_id", to: "comments#update"
  delete "posts/:id/comments/:comment_id", to: "comments#destroy"

  # Replies action
  get "posts/:post_id/comments/:comment_id/replies", to: "replies#index"
  get "posts/:post_id/comments/:comment_id/replies/:id", to: "replies#show"
  post "posts/:post_id/comments/:comment_id/replies", to: "replies#create"
  put "posts/:post_id/comments/:comment_id/replies/:id", to: "replies#update"
  delete "posts/:post_id/comments/:comment_id/replies/:id", to: "replies#destroy"

    # Authentication actions
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
    },
   controllers: {
     sessions: 'users/sessions',
     registrations: 'users/registrations'
   }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
