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
      resources :senales
      resources :usuarios
      resources :empresas
      get 'paises/:campo/:valor/:db', to: 'paises#show'
      get 'paises/bd/:db', to: 'paises#index'
      get 'ciudades/:campo/:valor', to: 'ciudades#show'
      get 'ciudades/bd/:db', to: 'ciudades#index'
      get 'bancos/:campo/:valor', to: 'bancos#show'
      get 'bancos/bd/:db', to: 'ciudades#index'
      get 'zonas/:campo/:valor', to: 'zonas#show'
      get 'zonas/bd/:db', to: 'ciudades#index'
      get 'barrios/:campo/:valor', to: 'barrios#show'
      get 'barrios/bd/:db', to: 'ciudades#index'
      get 'conceptos/:campo/:valor', to: 'conceptos#show'
      get 'planes/:campo/:valor', to: 'planes#show'
      get 'tarifas/:campo/:valor', to: 'tarifas#show'
      get 'senales/:campo/:valor', to: 'senales#show'
      get 'usuarios/:campo/:valor', to: 'usuarios#show'
      post 'usuarios/cambiar_password/:id', to: 'usuarios#cambiar_password'
      post 'usuarios/resetear_password/:id', to: 'usuarios#resetear_password'
      get 'empresas/:campo/:valor', to: 'empresas#show'
      post 'signin', to: 'sesion#create'
      delete 'signout', to: 'sesion#destroy'
    end
  end
end
