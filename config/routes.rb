Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :events do
    collection do
      get :by_tag, to: 'events#by_tag'
      get "buckets/:id", to: "events#for_bucket"
    end
  end

  resources :buckets do
  end


  root to: 'pages#index'

end
