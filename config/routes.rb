Rails.application.routes.draw do
  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :paises
      resources :departamentos
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
      resources :tipo_facturacion
      resources :facturacion
      resources :pagos
      resources :pagos_anticipados
      resources :ordenes
      get 'paises/bd/:db', to: 'paises#index'
      get 'paises/:campo/:valor/:db', to: 'paises#show'
      get 'departamentos/bd/:db', to: 'departamentos#index'
      get 'departamentos/:campo/:valor/:db', to: 'departamentos#show'
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
      get 'senales/:funcion_id/bd/:db', to: 'senales#index'
      get 'senales/:funcion_id/:campo/:valor/:db', to: 'senales#show'
      get 'senales/listado_consol/:db', to: 'senales#listado_consolidado'
      get 'senales/listado_tv/:db', to: 'senales#listado_television'
      get 'senales/listado_int/:db', to: 'senales#listado_internet'
      get 'usuarios/bd/:db', to: 'usuarios#index'
      get 'usuarios/:campo/:valor/:db', to: 'usuarios#show'
      post 'usuarios/cambiar_password/:id', to: 'usuarios#cambiar_password'
      post 'usuarios/resetear_password/:id', to: 'usuarios#resetear_password'
      get 'empresas/bd/:db', to: 'empresas#index'
      get 'empresas/:campo/:valor/:db', to: 'empresas#show'
      get 'tipo_facturacion/bd/:db', to: 'tipo_facturacion#index'
      get 'tipo_facturacion/:campo/:valor/:db', to: 'tipo_facturacion#show'
      get 'facturacion/bd/:db', to: 'facturacion#index'
      get 'facturacion/facturas/:entidad_id/:db', to: 'facturacion#index_facturas'
      get 'facturacion/info/bd/:db', to: 'facturacion#info_facturacion'
      post 'facturacion/factura_manual', to: 'facturacion#create_factura'
      get 'facturacion/generar_impresion/:db', to: 'facturacion#generar_facturacion'
      post 'facturacion/anular_factura', to: 'facturacion#anular_factura'
      get 'pagos/bd/:db', to: 'pagos#index'
      get 'pagos/detalle_facturas/:entidad_id/:db', to: 'pagos#index_pago'
      get 'pagos/:campo/:valor/:db', to: 'pagos#show'
      post 'pagos/anular_pago/:id', to: 'pagos#anular'
      get 'pagos_anticipados/bd/:db', to: 'pagos_anticipados#index'
      get 'pagos_anticipados/info/bd/:db', to: 'pagos_anticipados#index_info'
      get 'pagos_anticipados/:campo/:valor/:db', to: 'pagos_anticipados#show'
      post 'pagos_anticipados/anular_pago/:id', to: 'pagos_anticipados#anular'
      get 'ordenes/bd/:db', to: 'ordenes#index'
      get 'ordenes/info/bd/:db', to: 'ordenes#index_info'
      post 'ordenes/anular_orden/:id', to: 'ordenes#anular'
      post 'signin', to: 'sesion#create'
      delete 'signout', to: 'sesion#destroy'
    end
  end
end
