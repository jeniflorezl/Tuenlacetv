Rails.application.routes.draw do
  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :paises
      resources :ciudades
      resources :bancos
      resources :zonas
      resources :barrios
      resources :conceptos
      resources :planes
      resources :tarifas
      get 'paises/:campo/:valor', to: 'paises#show'
      get 'ciudades/:campo/:valor', to: 'ciudades#show'
      get 'bancos/:campo/:valor', to: 'bancos#show'
      get 'zonas/:campo/:valor', to: 'zonas#show'
      get 'barrios/:campo/:valor', to: 'barrios#show'
      get 'conceptos/:campo/:valor', to: 'conceptos#show'
      get 'planes/:campo/:valor', to: 'planes#show'
      get 'tarifas/:campo/:valor', to: 'tarifas#show'
    end
  end
end
