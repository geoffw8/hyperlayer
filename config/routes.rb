Hyperlayer::Engine.routes.draw do
  resources :runs, only: [:index] do
    resources :specs, only: [:index, :show] do
      resources :example_groups do
        resources :events, only: [:index]
      end
    end
  end

  root 'runs#index'
end
