require 'rails_helper'

RSpec.describe Api::V1::SesionController, type: :request do

    describe 'POST create' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        post "http://localhost:3000/api/v1/signin", :params => '{ "login": "admin", "password": "123" }', :headers => headers
        expect(response).to have_http_status(:ok)
      end

      it 'Invalid login' do
        post "http://localhost:3000/api/v1/signin", :params => '{ "login": "jeniferfl", "password": "1234" }'
        expect(response).to have_http_status(:unauthorized)
      end
    end
=begin
    describe 'DELETE delete' do
      it 'ok' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Bearer 57f58b86dd567bd33a309a1234bc73e9"}
        delete "http://localhost:3000/api/v1/signout", :headers => headers
        expect(response).to have_http_status(:ok)
      end
     
      it '401 Unauthorized' do
        headers = { 
          "Content-Type" => "application/json",
          "Accept" => "application/json"}
        delete "http://localhost:3000/api/v1/signout", :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
=end
end