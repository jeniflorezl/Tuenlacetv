require 'rails_helper'
require 'airborne'

RSpec.describe Api::V1::PaisesController, type: :controller do

    describe 'GET index' do
      it 'ok' do
        post 'http:localhost:3000/api/v1/paises', { :nombre => 'Uruguay', :usuario_id => 1 }, { 'x-auth-token' => 'ddc0acb5bd5393d845e3af9c5217a2c5' }
        expect(response).to have_http_status(:ok)
      end
    end
end