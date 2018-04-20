require 'rails_helper'

RSpec.describe Api::V1::PagosAnticipadosController, type: :request do

    describe 'GET index' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        get "http://localhost:3000/api/v1/pagos_anticipados/bd/PRUEBAS", :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        get "http://localhost:3000/api/v1/pagos_anticipados/bd/PRUEBAS", :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'GET index information for create anticipated payments' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        get "http://localhost:3000/api/v1/pagos_anticipados/info/bd/PRUEBAS", :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        get "http://localhost:3000/api/v1/pagos_anticipados/info/bd/PRUEBAS", :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'POST create' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        post "http://localhost:3000/api/v1/pagos_anticipados", :params => '{ "entidad_id": 4, "documento_id": 3, "servicio_id": 1, "fechatrn": "05/04/2018", "fechapxa": "01/04/2018", "valor": 105000, "descuento": 0, "observacion": "pago anticipado mensualidad internet", "forma_pago_id": 1, "banco_id": 1, "cobrador_id": 50002, "usuario_id": 1, "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        post "http://localhost:3000/api/v1/pagos_anticipados", :params => '{ "entidad_id": 4, "documento_id": 3, "servicio_id": 1, "fechatrn": "05/04/2018", "fechapxa": "01/04/2018", "valor": 105000, "descuento": 0, "observacion": "pago anticipado mensualidad internet", "forma_pago_id": 1, "banco_id": 1, "cobrador_id": 50002, "usuario_id": 1, "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'POST cancel' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        post "http://localhost:3000/api/v1/pagos_anticipados/anular_pago/76", :params => '{ "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('{"status":"anulado"}')
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        post "http://localhost:3000/api/v1/pagos_anticipados/anular_pago/76", :params => '{ "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
end