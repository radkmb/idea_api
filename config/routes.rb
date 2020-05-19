Rails.application.routes.draw do
  get "/ideas", to: "ideas#index"
  post "/ideas", to: "ideas#create"
end
