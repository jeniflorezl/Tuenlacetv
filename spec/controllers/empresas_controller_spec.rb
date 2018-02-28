require 'rails_helper'

RSpec.describe Api::V1::EmpresasController, type: :request do

    describe 'GET index' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        get "http://localhost:3000/api/v1/empresas", :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        get "http://localhost:3000/api/v1/empresas", :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'POST create' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        post "http://localhost:3000/api/v1/empresas", :params => '{ "tipo": "01", "nit": "900353347", "razonsocial": "ENLACE INFORMATICO S.A.S", "direccion": "CRA 47 #53-41", "telefono1": "4540312", "telefono2": "", "ciudad_id": 1, "entidad_id": 1, "logo": "", "correo": "gerencia@enlaceinformatico.com", "regimen": "S", "contribuyente": "S", "centrocosto": "0001", "usuario_id": 1 }', :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it 'Unprocessable Entity' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        post "http://localhost:3000/api/v1/empresas", :params => '{ "tipo": "01", "nit": "900353347", "razonsocial": "ENLACE INFORMATICO S.A.S", "direccion": "CRA 47 #53-41", "telefono1": "4540312", "telefono2": "", "ciudad_id": 1, "entidad_id": 1, "logo": "", "correo": "gerencia@enlaceinformatico.com", "regimen": "S" }', :headers => headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        post "http://localhost:3000/api/v1/empresas", :params => '{ "tipo": "01", "nit": "900353347", "razonsocial": "ENLACE INFORMATICO S.A.S", "direccion": "CRA 47 #53-41", "telefono1": "4540312", "telefono2": "", "ciudad_id": 1, "entidad_id": 1, "logo": "", "correo": "gerencia@enlaceinformatico.com", "regimen": "S", "contribuyente": "S", "centrocosto": "0001", "usuario_id": 1 }', :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PUT update' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        put "http://localhost:3000/api/v1/empresas/1", :params => '{ "tipo": "01", "nit": "900353347", "razonsocial": "ENLACE INFORMATICO S.A.S", "direccion": "CRA 47 #53-41", "telefono1": "4540312", "telefono2": "", "ciudad_id": 1, "entidad_id": 1, "logo": "", "correo": "gerencia@enlaceinformatico.com", "regimen": "S", "contribuyente": "S", "centrocosto": "0001", "usuario_id": 1 }', :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it 'Not Found' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        put "http://localhost:3000/api/v1/empresas/30", :params => '{ "tipo": "01", "nit": "900353347", "razonsocial": "ENLACE INFORMATICO S.A.S", "direccion": "CRA 47 #53-41", "telefono1": "4540312", "telefono2": "", "ciudad_id": 1, "entidad_id": 1, "logo": "", "correo": "gerencia@enlaceinformatico.com", "regimen": "S", "contribuyente": "S", "centrocosto": "0001", "usuario_id": 1 }', :headers => headers
        expect(response).to have_http_status(:not_found)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        put "http://localhost:3000/api/v1/empresas/1", :params => '{ "tipo": "01", "nit": "900353347", "razonsocial": "ENLACE INFORMATICO S.A.S", "direccion": "CRA 47 #53-41", "telefono1": "4540312", "telefono2": "", "ciudad_id": 1, "entidad_id": 1, "logo": "", "correo": "gerencia@enlaceinformatico.com", "regimen": "S", "contribuyente": "S", "centrocosto": "0001", "usuario_id": 1 }', :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'DELETE delete' do
      it 'ok if it is foreign key' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        delete "http://localhost:3000/api/v1/empresas/1", :headers => headers
        expect(response).to have_http_status(:bad_request)
      end

      it 'Not Found' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        delete "http://localhost:3000/api/v1/empresas/30", :headers => headers
        expect(response).to have_http_status(:not_found)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        delete "http://localhost:3000/api/v1/empresas/1", :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
end