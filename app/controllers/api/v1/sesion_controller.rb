module Api
    module V1
        class SesionController < ApplicationController
            skip_before_action :require_login!, only: [:create]

            def create
                usuario = Usuario.find_by(login: params[:login])
                usuario ||= Usuario.new

                if usuario.login_valido?(params[:login],params[:password])
                    auth_token = usuario.generar_auth_token
                    render json: { auth_token: auth_token }
                else
                    login_invalido
                end

            end

            def destroy
                usuario = current_user
                usuario.invalidar_auth_token
                head :ok
            end

            private

                def login_invalido
                    render json: { errors: [ { detail:"Error con tu nombre 
                    de usuario y/o contraseña" }]}, status: 401
                end
        end
    end
end