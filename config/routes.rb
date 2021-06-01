Rails.application.routes.draw do
  devise_for :users
  resources :users do
    resources :notes do
      member do
        get :share_note
        post :share
        delete :remove_shared_user
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "home#index"
end
