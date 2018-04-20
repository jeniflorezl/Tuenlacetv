require 'rails_helper'

RSpec.describe Api::V1::OrdenesController, type: :request do

    describe 'GET index' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        get "http://localhost:3000/api/v1/ordenes/bd/PRUEBAS", :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        get "http://localhost:3000/api/v1/ordenes/bd/PRUEBAS", :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'GET index information for create order' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        get "http://localhost:3000/api/v1/ordenes/info/bd/PRUEBAS", :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        get "http://localhost:3000/api/v1/ordenes/info/bd/PRUEBAS", :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'POST create' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        post "http://localhost:3000/api/v1/ordenes", :params => '{ "entidad_id": 7, "concepto_id": "5", "fechatrn": "12/04/2018", "fechaven": "12/04/2018", "valor": 21000, "observacion": "pto adicional", "tecnico_id": 50001, "zonaNue": null, "barrioNue": null, "direccionNue": null, "usuario_id": 1, "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        post "http://localhost:3000/api/v1/ordenes", :params => '{ "entidad_id": 7, "concepto_id": "5", "fechatrn": "12/04/2018", "fechaven": "12/04/2018", "valor": 21000, "observacion": "pto adicional", "tecnico_id": 50001, "zonaNue": null, "barrioNue": null, "direccionNue": null, "usuario_id": 1, "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PUT update' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        put "http://localhost:3000/api/v1/ordenes/49", :params => '{ "fechaven": "16/04/2018", "observacion": "pto adicional", "tecnico_id": 50001, "solicita": "el usuario", "detalle": [ { "articulo_id": 3, "cantidad": 1, "valor": 2521, "porcentajeIva": 19, "iva": 479, "total": 3000 } ], "solucion": "se adiciono un pto", "respuesta": "S", "usuario_id": 1, "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('{"status":"updated"}')
      end

      it 'Not Found' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        put "http://localhost:3000/api/v1/ordenes/200", :params => '{ "fechaven": "16/04/2018", "observacion": "pto adicional", "tecnico_id": 50001, "solicita": "el usuario", "detalle": [ { "articulo_id": 3, "cantidad": 1, "valor": 2521, "porcentajeIva": 19, "iva": 479, "total": 3000 } ], "solucion": "se adiciono un pto", "respuesta": "S", "usuario_id": 1, "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('{"error":"not found"}')
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        put "http://localhost:3000/api/v1/ordenes/49", :params => '{ "fechaven": "16/04/2018", "observacion": "pto adicional", "tecnico_id": 50001, "solicita": "el usuario", "detalle": [ { "articulo_id": 3, "cantidad": 1, "valor": 2521, "porcentajeIva": 19, "iva": 479, "total": 3000 } ], "solucion": "se adiciono un pto", "respuesta": "S", "usuario_id": 1, "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'POST cancel' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        post "http://localhost:3000/api/v1/ordenes/anular_orden/48", :params => '{ "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('{"status":"anulada"}')
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        post "http://localhost:3000/api/v1/ordenes/anular_orden/48", :params => '{ "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
end