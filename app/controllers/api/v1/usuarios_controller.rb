module Api
    module V1
        class UsuariosController < ApplicationController
            before_action :set_usuario_buscar, only: [:show]
            before_action :set_usuario, only: [:update, :destroy, :cambiar_password, :resetear_password]
            
                # GET /usuarios
                def index
                    if current_user.admin?
                        @usuarios = Usuario.all
                    else
                        @usuario = current_user
                        @usuarios = [*@usuario]
                    end
                    @estados = Estado.where("abreviatura = 'A' or abreviatura = 'IN'")
                end
            
                # GET /usuarios/id
                # GET /usuarios/login
                # GET /usuarios/nombre
                def show
                end
            
                # POST /usuarios
                def create
                    if current_user.admin?
                        #byebug
                        @usuario = Usuario.new(usuario_params)
                  
                        if @usuario.save 
                            render json: { status: :created }
                        else
                            render json: @usuario.errors, status: :unprocessable_entity
                        end
                    else
                        render json: { message: "Permiso denegado" }
                    end
                end
            
                # PATCH/PUT /usuarios/id
                def update
                    t = Time.now
                    @usuario.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                    if @usuario.update(usuario_params)
                        render json: { status: :updated }
                    else
                        render json: @usuario.errors, status: :unprocessable_entity
                    end
                end
            
                # DELETE /usuarios/id
                def destroy
                    if @usuario
                        @usuario.destroy()
                        render json: { status: :deleted }
                    else
                        render json: { post: "not found" }
                    end
                end

                def cambiar_password
                    t = Time.now
                    if @usuario.validar_password(params[:antiguaP])
                        @usuario.password = params[:nuevaP]
                        @usuario.password_confirmation = params[:nuevaP]
                        @usuario.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                        if @usuario.update(usuario_params)
                            render json: { message: "Contraseña actualizada!" }
                        else
                            render json: { message: "Error!" }
                        end
                    else
                        render json: { message: "Contraseña antigua incorrecta!" }
                    end
                end

                def resetear_password
                    t = Time.now
                    @usuario.password = params[:nuevaP]
                    @usuario.password_confirmation = params[:nuevaP]
                    @usuario.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                    if @usuario.update(usuario_params)
                        render json: { message: "Contraseña cambiada!" }
                    else
                        render json: { message: "Error!" }
                    end
                end

                private

                # Me busca la usuario por el id, por la zona, el concepto, el plan, el valor, o el
                # estado
                def set_usuario_buscar
                    @campo = params[:campo]
                    @valor = params[:valor]
                    if @campo == 'id'
                        @usuario = Usuario.find(params[:valor])
                    else
                        @usuario = Usuario.limit(10).where("#{@campo} LIKE '%#{@valor}%'")
                    end
                    @usuario = [*@usuario]
                end

                def set_usuario
                    @usuario = Usuario.find(params[:id])
                end

                #Le coloco los parametros que necesito del usuario para crearlo y actualizarlo
                # Reemplazamos :password_digest por :password y :password_confirmation
                def usuario_params
                    params.permit(:login, :nombre, :password, :password_confirmation,
                    :nivel,  :estado_id, :tipoImpresora, :usuariocre)
                end 
        end
    end
end