require 'rails_helper'

RSpec.describe Api::V1::BancosController, type: :request do

    describe 'GET index' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        get "http://localhost:3000/api/v1/bancos/bd/PRUEBAS", :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        get "http://localhost:3000/api/v1/bancos/bd/PRUEBAS", :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'GET show' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        get "http://localhost:3000/api/v1/bancos/id/2/PRUEBAS", :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        get "http://localhost:3000/api/v1/bancos/id/2/PRUEBAS", :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'POST create' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        post "http://localhost:3000/api/v1/bancos", :params => '{ "nit": "800226788", "nombre": "CAJA GENERAL", "direccion": "", "ciudad_id": 1, "telefono1": "0", "telefono2": "0", "contacto": "", "cuentaBancaria": "110505", "cuentaContable": "", "usuario_id": 1, "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it 'Unprocessable Entity' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        post "http://localhost:3000/api/v1/bancos", :params => '{ "nit": "800226788" }', :headers => headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        post "http://localhost:3000/api/v1/bancos", :params => '{ "nit": "800226788", "nombre": "CAJA GENERAL", "direccion": "", "ciudad_id": 1, "telefono1": "0", "telefono2": "0", "contacto": "", "cuentaBancaria": "110505", "cuentaContable": "", "usuario_id": 1, "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PUT update' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        put "http://localhost:3000/api/v1/bancos/2", :params => '{ "nit": "800226788", "nombre": "CAJA GENERAL", "direccion": "", "ciudad_id": 1, "telefono1": "0", "telefono2": "0", "contacto": "", "cuentaBancaria": "110505", "cuentaContable": "", "usuario_id": 1, "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it 'Not Found' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        put "http://localhost:3000/api/v1/bancos/30", :params => '{ "nit": "800226788", "nombre": "CAJA GENERAL", "direccion": "", "ciudad_id": 1, "telefono1": "0", "telefono2": "0", "contacto": "", "cuentaBancaria": "110505", "cuentaContable": "", "usuario_id": 1, "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:not_found)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        put "http://localhost:3000/api/v1/bancos/1", :params => '{ "nit": "800226788", "nombre": "CAJA GENERAL", "direccion": "", "ciudad_id": 1, "telefono1": "0", "telefono2": "0", "contacto": "", "cuentaBancaria": "110505", "cuentaContable": "", "usuario_id": 1, "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'DELETE delete' do
      it 'ok if it is not foreign key' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        delete "http://localhost:3000/api/v1/bancos/3", :params => '{ "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it 'is not ok if it is foreign key' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        delete "http://localhost:3000/api/v1/bancos/1", :params => '{ "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:not_acceptable)
      end

      it 'Not Found' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        delete "http://localhost:3000/api/v1/bancos/30", :params => '{ "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:not_found)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        delete "http://localhost:3000/api/v1/bancos/6", :params => '{ "db": "PRUEBAS" }', :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
end