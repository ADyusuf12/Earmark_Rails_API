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
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
