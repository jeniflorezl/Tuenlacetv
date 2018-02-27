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
      get 'paises/bd/:db', to: 'paises#index'
      get 'paises/:campo/:valor/:db', to: 'paises#show'
      get 'ciudades/bd/:db', to: 'ciudades#index'
      get 'ciudades/:campo/:valor', to: 'ciudades#show'
      get 'bancos/bd/:db', to: 'bancos#index'
      get 'bancos/:campo/:valor', to: 'bancos#show'
      get 'zonas/bd/:db', to: 'zonas#index'
      get 'zonas/:campo/:valor', to: 'zonas#show'
      get 'barrios/bd/:db', to: 'barrios#index'
      get 'barrios/:campo/:valor', to: 'barrios#show'
      get 'conceptos/bd/:db', to: 'conceptos#index'
      get 'conceptos/:campo/:valor', to: 'conceptos#show'
      get 'planes/bd/:db', to: 'planes#index'
      get 'planes/:campo/:valor', to: 'planes#show'
      get 'tarifas/bd/:db', to: 'tarifas#index'
      get 'tarifas/:campo/:valor', to: 'tarifas#show'
      get 'senales/bd/:db', to: 'senales#index'
      get 'senales/:campo/:valor', to: 'senales#show'
      get 'usuarios/bd/:db', to: 'usuarios#index'
      get 'usuarios/:campo/:valor', to: 'usuarios#show'
      post 'usuarios/cambiar_password/:id', to: 'usuarios#cambiar_password'
      post 'usuarios/resetear_password/:id', to: 'usuarios#resetear_password'
      get 'empresas/bd/:db', to: 'empresas#index'
      get 'empresas/:campo/:valor', to: 'empresas#show'
      post 'signin', to: 'sesion#create'
      delete 'signout', to: 'sesion#destroy'
    end
  end
end
