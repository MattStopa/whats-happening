Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post "/graphql", to: "graphql#execute"
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :events do
    collection do
      get :by_tag, to: 'events#by_tag'
      get "buckets/:id", to: "events#for_bucket"
      get "charts/:id", to: "events#generate_chart"
    end
  end

  resources :buckets do
  end


  root to: 'pages#index'

end
