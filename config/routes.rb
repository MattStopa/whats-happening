Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :events do
    collection do
      get :by_tag, to: 'events#by_tag'
    end
  end


  root to: 'pages#index'

end
