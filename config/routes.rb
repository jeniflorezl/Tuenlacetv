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
      resources :facturacion
      resources :tipo_facturacion
      get 'paises/bd/:db', to: 'paises#index'
      get 'paises/:campo/:valor/:db', to: 'paises#show'
      get 'ciudades/bd/:db', to: 'ciudades#index'
      get 'ciudades/:campo/:valor/:db', to: 'ciudades#show'
      get 'bancos/bd/:db', to: 'bancos#index'
      get 'bancos/:campo/:valor/:db', to: 'bancos#show'
      get 'zonas/bd/:db', to: 'zonas#index'
      get 'zonas/:campo/:valor/:db', to: 'zonas#show'
      get 'barrios/bd/:db', to: 'barrios#index'
      get 'barrios/:campo/:valor/:db', to: 'barrios#show'
      get 'conceptos/bd/:db', to: 'conceptos#index'
      get 'conceptos/:campo/:valor/:db', to: 'conceptos#show'
      get 'planes/bd/:db', to: 'planes#index'
      get 'planes/:campo/:valor/:db', to: 'planes#show'
      get 'tarifas/bd/:db', to: 'tarifas#index'
      get 'tarifas/:campo/:valor/:db', to: 'tarifas#show'
      get 'senales/bd/:db', to: 'senales#index'
      get 'senales/entidades/:funcion_id/:db', to: 'senales#index_entidad'
      get 'senales/:campo/:valor/:db', to: 'senales#show'
      get 'senales/listado/:db', to: 'senales#listado_suscriptores'
      get 'usuarios/bd/:db', to: 'usuarios#index'
      get 'usuarios/:campo/:valor/:db', to: 'usuarios#show'
      post 'usuarios/cambiar_password/:id', to: 'usuarios#cambiar_password'
      post 'usuarios/resetear_password/:id', to: 'usuarios#resetear_password'
      get 'empresas/bd/:db', to: 'empresas#index'
      get 'empresas/:campo/:valor/:db', to: 'empresas#show'
      get 'tipo_facturacion/:db', to: 'tipo_facturacion#index'
      get 'tipo_facturacion/:campo/:valor/:db', to: 'tipo_facturacion#show'
      post 'facturacion/factura_manual/:db', to: 'facturacion#create_factura'
      post 'signin', to: 'sesion#create'
      delete 'signout', to: 'sesion#destroy'
    end
  end
end
