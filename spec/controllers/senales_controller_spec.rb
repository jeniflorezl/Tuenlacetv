require 'rails_helper'

RSpec.describe Api::V1::SenalesController, type: :request do

    describe 'GET index' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        get "http://localhost:3000/api/v1/senales", :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        get "http://localhost:3000/api/v1/senales", :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'POST create' do
      it 'ok without internet' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        post "http://localhost:3000/api/v1/senales", :params => '{ "persona": { "tipo_documento_id": 1, "documento": "1020470055", "nombre1": "JENIFFER", "nombre2": "", "apellido1": "FLÓREZ", "apellido2": "LONDOÑO", "direccion": "CRA 47 #53-41", "barrio_id": 1, "zona_id": 1, "telefono1": "4540312", "telefono2": "", "correo": "jeniferfl@gmail.com", "fechanac": "1995-07-13", "tipopersona": "N", "estrato": 3, "condicionfisica": "N", "usuario_id": 1 }, "senal": { "servicio_id": 1, "contrato": "4789963", "direccion": "CALLE 11 #24-23", "urbanizacion": "", "torre": "", "apto": "", "barrio_id": 1, "zona_id": 1, "telefono1": "4540312", "telefono2": "", "contacto": "", "estrato": 4, "vivienda": "P",  "observacion": "", "estado_id": 1, "fechacontrato": "2017-01-01", "permanencia": null, "televisores": 2, "decos": "", "precinto": "12321", "vendedor_id": 7, "tipo_instalacion_id": 1,"tecnologia_id": 1,"tiposervicio": "R", "areainstalacion": "U", "usuario_id": 1 }, "funcion_id": 1, "internet": 0 }', :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it 'ok with internet' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        post "http://localhost:3000/api/v1/senales", :params => '{ "persona": { "tipo_documento_id": 1, "documento": "1020470055", "nombre1": "JENIFFER", "nombre2": "", "apellido1": "FLÓREZ", "apellido2": "LONDOÑO", "direccion": "CRA 47 #53-41", "barrio_id": 1, "zona_id": 1, "telefono1": "4540312", "telefono2": "", "correo": "jeniferfl@gmail.com", "fechanac": "1995-07-13", "tipopersona": "N", "estrato": 3, "condicionfisica": "N", "usuario_id": 1 }, "senal": { "servicio_id": 1, "contrato": "4789963", "direccion": "CALLE 11 #24-23", "urbanizacion": "", "torre": "", "apto": "", "barrio_id": 1, "zona_id": 1, "telefono1": "4540312", "telefono2": "", "contacto": "", "estrato": 4, "vivienda": "P",  "observacion": "", "estado_id": 1, "fechacontrato": "2017-01-01", "permanencia": null, "televisores": 2, "decos": "", "precinto": "12321", "vendedor_id": 7, "tipo_instalacion_id": 1,"tecnologia_id": 1,"tiposervicio": "R", "areainstalacion": "U", "usuario_id": 1 }, "funcion_id": 1, "internet": 1, "info_internet": { "direccionip": "127.0.0.0.0", "velocidad": 3, "mac1": "127.0.0.0.0", "mac2": "127.0.0.0.0", "serialm": "serial", "marcam": "mer", "mascarasub": "127.0.0.0.0", "dns": "127.0.0.0.0", "gateway": "127.0.0.0.0", "nodo": 1, "clavewifi": "182293293290", "equipo": "S"}}', :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it 'Unprocessable Entity' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        post "http://localhost:3000/api/v1/senales", :params => '{ "persona": { "tipo_documento_id": 1, "documento": "1020470055", "nombre1": "JENIFFER", "nombre2": "", "apellido1": "FLÓREZ", "apellido2": "LONDOÑO", "direccion": "CRA 47 #53-41", "barrio_id": 1, "zona_id": 1, "telefono1": "4540312", "telefono2": "", "correo": "jeniferfl@gmail.com", "fechanac": "1995-07-13", "tipopersona": "N", "estrato": 3, "condicionfisica": "N", "usuario_id": 1 }, "senal": { "servicio_id": 1, "contrato": "4789963", "direccion": "CALLE 11 #24-23", "urbanizacion": "", "torre": "", "apto": "", "barrio_id": 1, "zona_id": 1, "telefono1": "4540312", "telefono2": "", "contacto": "", "estrato": 4, "vivienda": "P",  "observacion": "", "estado_id": 1, "fechacontrato": "2017-01-01", "permanencia": null, "televisores": 2, "decos": "", "precinto": "12321", "vendedor_id": 7, "tipo_instalacion_id": 1,"tecnologia_id": 1,"tiposervicio": "R" }, "funcion_id": 1, "internet": 1 }', :headers => headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        post "http://localhost:3000/api/v1/senales", :params => '{ "persona": { "tipo_documento_id": 1, "documento": "1020470055", "nombre1": "JENIFFER", "nombre2": "", "apellido1": "FLÓREZ", "apellido2": "LONDOÑO", "direccion": "CRA 47 #53-41", "barrio_id": 1, "zona_id": 1, "telefono1": "4540312", "telefono2": "", "correo": "jeniferfl@gmail.com", "fechanac": "1995-07-13", "tipopersona": "N", "estrato": 3, "condicionfisica": "N", "usuario_id": 1 }, "senal": { "servicio_id": 1, "contrato": "4789963", "direccion": "CALLE 11 #24-23", "urbanizacion": "", "torre": "", "apto": "", "barrio_id": 1, "zona_id": 1, "telefono1": "4540312", "telefono2": "", "contacto": "", "estrato": 4, "vivienda": "P",  "observacion": "", "estado_id": 1, "fechacontrato": "2017-01-01", "permanencia": null, "televisores": 2, "decos": "", "precinto": "12321", "vendedor_id": 7, "tipo_instalacion_id": 1,"tecnologia_id": 1,"tiposervicio": "R", "areainstalacion": "U", "usuario_id": 1 }, "funcion_id": 1, "internet": 0 }', :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PUT update' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        put "http://localhost:3000/api/v1/senales/3", :params => '{ "persona": { "tipo_documento_id": 1, "documento": "1020470055", "nombre1": "JENIFFER", "nombre2": "", "apellido1": "FLÓREZ", "apellido2": "LONDOÑO", "direccion": "CRA 47 #53-41", "barrio_id": 1, "zona_id": 1, "telefono1": "4540312", "telefono2": "", "correo": "jeniferfl@gmail.com", "fechanac": "1995-07-13", "tipopersona": "N", "estrato": 3, "condicionfisica": "N", "usuario_id": 1 }, "senal": { "servicio_id": 1, "contrato": "4789963", "direccion": "CALLE 11 #24-23", "urbanizacion": "", "torre": "", "apto": "", "barrio_id": 1, "zona_id": 1, "telefono1": "4540312", "telefono2": "", "contacto": "", "estrato": 4, "vivienda": "P",  "observacion": "", "estado_id": 1, "fechacontrato": "2017-01-01", "permanencia": null, "televisores": 2, "decos": "", "precinto": "12321", "vendedor_id": 7, "tipo_instalacion_id": 1,"tecnologia_id": 1,"tiposervicio": "R", "areainstalacion": "U", "usuario_id": 1 }, "funcion_id": 1, "internet": 0 }', :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it 'Not Found' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        put "http://localhost:3000/api/v1/senales/50", :params => '{ "persona": { "tipo_documento_id": 1, "documento": "1020470055", "nombre1": "JENIFFER", "nombre2": "", "apellido1": "FLÓREZ", "apellido2": "LONDOÑO", "direccion": "CRA 47 #53-41", "barrio_id": 1, "zona_id": 1, "telefono1": "4540312", "telefono2": "", "correo": "jeniferfl@gmail.com", "fechanac": "1995-07-13", "tipopersona": "N", "estrato": 3, "condicionfisica": "N", "usuario_id": 1 }, "senal": { "servicio_id": 1, "contrato": "4789963", "direccion": "CALLE 11 #24-23", "urbanizacion": "", "torre": "", "apto": "", "barrio_id": 1, "zona_id": 1, "telefono1": "4540312", "telefono2": "", "contacto": "", "estrato": 4, "vivienda": "P",  "observacion": "", "estado_id": 1, "fechacontrato": "2017-01-01", "permanencia": null, "televisores": 2, "decos": "", "precinto": "12321", "vendedor_id": 7, "tipo_instalacion_id": 1,"tecnologia_id": 1,"tiposervicio": "R", "areainstalacion": "U", "usuario_id": 1 }, "funcion_id": 1, "internet": 0 }', :headers => headers
        expect(response).to have_http_status(:not_found)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        put "http://localhost:3000/api/v1/senales/1", :params => '{ "persona": { "tipo_documento_id": 1, "documento": "1020470055", "nombre1": "JENIFFER", "nombre2": "", "apellido1": "FLÓREZ", "apellido2": "LONDOÑO", "direccion": "CRA 47 #53-41", "barrio_id": 1, "zona_id": 1, "telefono1": "4540312", "telefono2": "", "correo": "jeniferfl@gmail.com", "fechanac": "1995-07-13", "tipopersona": "N", "estrato": 3, "condicionfisica": "N", "usuario_id": 1 }, "senal": { "servicio_id": 1, "contrato": "4789963", "direccion": "CALLE 11 #24-23", "urbanizacion": "", "torre": "", "apto": "", "barrio_id": 1, "zona_id": 1, "telefono1": "4540312", "telefono2": "", "contacto": "", "estrato": 4, "vivienda": "P",  "observacion": "", "estado_id": 1, "fechacontrato": "2017-01-01", "permanencia": null, "televisores": 2, "decos": "", "precinto": "12321", "vendedor_id": 7, "tipo_instalacion_id": 1,"tecnologia_id": 1,"tiposervicio": "R", "areainstalacion": "U", "usuario_id": 1 }, "funcion_id": 1, "internet": 0 }', :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'DELETE delete' do
      it 'ok if it is not foreign key' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        delete "http://localhost:3000/api/v1/senales/2", :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it 'ok if it is foreign key' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        delete "http://localhost:3000/api/v1/senales/11", :headers => headers
        expect(response).to have_http_status(:bad_request)
      end

      it 'Not Found' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        delete "http://localhost:3000/api/v1/senales/50", :headers => headers
        expect(response).to have_http_status(:not_found)
      end

      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        delete "http://localhost:3000/api/v1/senales/1", :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
end