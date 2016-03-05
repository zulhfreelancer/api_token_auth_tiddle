Rails.application.routes.draw do
  
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }
  get "posts" => "posts#index"

  # list of all available routes
  # [POST]    sign up user:   http://localhost:3000/users.json
  # [POST]    sign in user:   http://localhost:3000/users/sign_in.json
  # [DELETE]  sign out user:  http://localhost:3000/users/sign_out.json
  # [GET]     get all posts:  http://localhost:3000/posts.json
end
