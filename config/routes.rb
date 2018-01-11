Rails.application.routes.draw do
  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :paises
      resources :ciudades
      resources :zonas
      resources :barrios
      get 'paises/:campo/:valor', to: 'paises#show'
      get 'ciudades/:campo/:valor', to: 'ciudades#show'
      get 'zonas/:campo/:valor', to: 'zonas#show'
      get 'barrios/:campo/:valor', to: 'barrios#show'
    end
  end
end
