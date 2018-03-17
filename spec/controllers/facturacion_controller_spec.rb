require 'rails_helper'

RSpec.describe Api::V1::FacturacionController, type: :request do

    describe 'GET index' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        get "http://localhost:3000/api/v1/facturacion", :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        get "http://localhost:3000/api/v1/facturacion", :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'POST create' do
      it 'ok create billing' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        post "http://localhost:3000/api/v1/facturacion", :params => '{ "tipo_fact_id": 1, "f_elaboracion": "01/03/2018", "f_inicio": "01/03/2018", "f_fin": "30/03/2018", "f_vence": "30/03/2018", "f_corte": "28/03/2018", "f_vencidos": "20/03/2018", "observa": "MENSUALIDAD MARZO", "zona": "Todos", "usuario_id": 1 }', :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it 'ok create manual bill' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        post "facturacion/factura_manual/TUENLACETV", :params => '{ "tipo_facturacion_id": 1, "servicio_id": 2, "f_elaboracion": "01/03/2018", "f_inicio": "01/03/2018", "f_fin": "30/03/2018", "entidad_id": 7, "valor": 25000, "observa": "MENSUALIDAD MARZO", "usuario_id": 1 }', :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it 'Internal Server Error' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        post "http://localhost:3000/api/v1/facturacion", :params => '{ "tipo_fact_id": 1, "f_elaboracion": "01/03/2018", "f_inicio": "01/03/2018", "f_fin": "30/03/2018", "f_vence": "30/03/2018", "f_corte": "28/03/2018", "f_vencidos": "20/03/2018", "observa": "MENSUALIDAD MARZO" }', :headers => headers
        expect(response).to have_http_status(:internal_server_error)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        post "http://localhost:3000/api/v1/facturacion", :params => '{ "tipo_fact_id": 1, "f_elaboracion": "01/03/2018", "f_inicio": "01/03/2018", "f_fin": "30/03/2018", "f_vence": "30/03/2018", "f_corte": "28/03/2018", "f_vencidos": "20/03/2018", "observa": "MENSUALIDAD MARZO", "zona": "Todos", "usuario_id": 1 }', :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
end