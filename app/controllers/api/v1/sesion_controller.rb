module Api
    module V1
        class SesionController < ApplicationController
            skip_before_action :require_login!, only: [:create]

            def create
                usuario1 = Usuario.find_by(login: params[:login])
                usuario1 ||= Usuario.new

                if usuario1.login_valido?(params[:login],params[:password])
                    auth_token = usuario1.generar_auth_token
                    render json: { auth_token: auth_token, 
                        usuario_id: usuario1.id, nivel: usuario1.nivel}
                else
                    login_invalido
                end

            end

            def destroy
                usuario1 = current_user
                usuario1.invalidar_auth_token
                render json: { status: :deleted }
            end

            private

                def login_invalido
                    render json: { errors: [ { detail:"Error con tu nombre de usuario y/o contraseña" }]}, status: 401
                end
        end
    end
end