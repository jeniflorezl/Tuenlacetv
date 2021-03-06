require 'rails_helper'

RSpec.describe Api::V1::UsuariosController, type: :request do

    describe 'GET index' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        get "http://localhost:3000/api/v1/usuarios/bd/PRUEBAS", :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        get "http://localhost:3000/api/v1/usuarios/bd/PRUEBAS", :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'GET show' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        get "http://localhost:3000/api/v1/usuarios/id/1/PRUEBAS", :headers => headers
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST create' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        post "http://localhost:3000/api/v1/usuarios", :params => '{ "login": "admin", "nombre": "ADMINISTRADOR DEL SISTEMA", "password": "123", "password_confirmation": "123", "nivel": "1", "estado_id": 1, "tipoImpresora": "L", "usuariocre": "admin", "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:ok)
      end
=begin
      it 'ok change password' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        post "http://localhost:3000/api/v1/usuarios/cambiar_password/1", :params => '{ "antiguaP": "123", "nuevaP": "123", db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it 'ok reset password' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        post "http://localhost:3000/api/v1/usuarios/resetear_password/1", :params => '{ "nuevaP": "123", "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:ok)
      end
=end
      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        post "http://localhost:3000/api/v1/usuarios", :params => '{ "login": "admin", "nombre": "ADMINISTRADOR DEL SISTEMA", "password": "123", "password_confirmation": "123", "nivel": "1", "estado_id": 1, "tipoImpresora": "L", "usuariocre": "admin", "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PUT update' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        put "http://localhost:3000/api/v1/usuarios/1", :params => '{ "login": "admin", "nombre": "ADMINISTRADOR DEL SISTEMA", "password": "123", "password_confirmation": "123", "nivel": "1", "estado_id": 1, "tipoImpresora": "L", "usuariocre": "admin", "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it 'Not Found' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        put "http://localhost:3000/api/v1/usuarios/30", :params => '{ "login": "admin", "nombre": "ADMINISTRADOR DEL SISTEMA", "password": "123", "password_confirmation": "123", "nivel": "1", "estado_id": 1, "tipoImpresora": "L", "usuariocre": "admin", "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:not_found)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        put "http://localhost:3000/api/v1/usuarios/1", :params => '{ "login": "admin", "nombre": "ADMINISTRADOR DEL SISTEMA", "password": "123", "password_confirmation": "123", "nivel": "1", "estado_id": 1, "tipoImpresora": "L", "usuariocre": "admin", "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'DELETE delete' do
=begin
      it 'ok if it is not foreign key' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        delete "http://localhost:3000/api/v1/usuarios/2", :params => '{ "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:ok)
      end
=end
      it 'is not ok if it is foreign key' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        delete "http://localhost:3000/api/v1/usuarios/1", :params => '{ "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:not_acceptable)
      end

      it 'Not Found' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        delete "http://localhost:3000/api/v1/usuarios/30", :params => '{ "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:not_found)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        delete "http://localhost:3000/api/v1/usuarios/1", :params => '{ "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
end