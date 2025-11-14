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

      get "home", to: "api/v1/home#index"
      resource :user_profile, only: [ :show, :update ], controller: "api/v1/user_profiles"
      resources :user_profiles, only: [ :show, :update ], controller: "api/v1/user_profiles"
      resources :listings, controller: "api/v1/listings" do
        resources :enquiries, only: [ :create, :index ], controller: "api/v1/enquiries"
      end
      get "enquiries", to: "api/v1/enquiries#my_enquiries"
      resources :saved_listings, only: [ :index, :create, :destroy ], controller: "api/v1/saved_listings"

      scope :dashboard, module: "api/v1/dashboard" do
        resource :overview, only: [ :show ], controller: "overviews"
        resources :listings, only: [ :index, :create, :show, :update, :destroy ]
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
