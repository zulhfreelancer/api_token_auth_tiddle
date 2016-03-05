Rails.application.routes.draw do

  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }
  get "posts" => "posts#index"
  root "static_pages#home"

  # ============================
  # list of all available routes
  # ============================

  # will go to Devise RegistrationsController
  # [POST]    sign up user:   	http://localhost:3000/users.json
  # [PUT]	  change password: 	http://localhost:3000/users.json

  # will go to Devise SessionsController
  # [POST]    sign in user:   	http://localhost:3000/users/sign_in.json
  # [DELETE]  sign out user:  	http://localhost:3000/users/sign_out.json

  # [GET]     get all posts:  http://localhost:3000/posts.json
end
