Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      devise_for :users,
                 defaults: { format: :json },
                 skip: [ :passwords ],
                 controllers: {
                  sessions: "api/v1/sessions",
                  registrations: "api/v1/registrations"
                 }

      devise_scope :user do
        post   "login",  to: "api/v1/sessions#create"
        delete "logout", to: "api/v1/sessions#destroy"
        post "register", to: "api/v1/registrations#create"
      end

      get "profile", to: "api/v1/profiles#show"
      patch "profile", to: "api/v1/profiles#update"
      put "profile", to: "api/v1/profiles#update"

      get "listings", to: "api/v1/listings#index"
      post "listings", to: "api/v1/listings#create"
      get "listings/:id", to: "api/v1/listings#show"
      put "listings/:id", to: "api/v1/listings#update"
      patch "listings/:id", to: "api/v1/listings#update"
      delete "listings/:id", to: "api/v1/listings#destroy"
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
