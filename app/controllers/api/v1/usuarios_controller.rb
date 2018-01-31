module Api
    module V1
        class UsuariosController < ApplicationController
            before_action :set_usuario_buscar, only: [:show]
            before_action :set_usuario, only: [:update, :destroy]
            
                # GET /usuarios
                def index
                    @usuarios = usuario.all
                    @zonas = Zona.all
                    @conceptos = Concepto.all
                    @planes = Plan.all
                end
            
                # GET /usuarios/id
                # GET /usuarios/zona_id
                # GET /usuarios/concepto_id
                # GET /usuarios/plan_id
                # GET /usuarios/valor
                # GET /usuarios/estado
                def show
                end
            
                # POST /usuarios
                # POST /usuarios.json
                def create
                    @usuario = usuario.new(usuario_params)
                    if @usuario.save 
                        render json: { status: :created }
                    else
                        render json: @usuario.errors, status: :unprocessable_entity
                    end
                end
            
                # PATCH/PUT /usuarios/id
                # PATCH/PUT /usuarios/id.json
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
                # DELETE /usuarios/id.json
                def destroy
                    if @usuario
                        @usuario.destroy()
                        render json: { status: :deleted }
                    else
                        render json: { post: "not found" }
                    end
                end
            
                private

                # Me busca la usuario por el id, por la zona, el concepto, el plan, el valor, o el
                # estado
                def set_usuario_buscar
                    @campo = params[:campo]
                    @valor = params[:valor]
                    if @campo == 'codigo'
                        @usuario = usuario.find(params[:valor])
                    elsif @campo == 'zona'
                        @usuario = usuario.limit(10).where(zona_id: @valor)
                    elsif @campo == 'concepto'
                        @usuario = usuario.limit(10).where(concepto_id: @valor)
                    elsif @campo == 'plan'
                        @usuario = usuario.limit(10).where(plan_id: @valor)
                    else
                        @usuario = usuario.limit(10).where(valor: @valor)
                    end
                    @usuario = [*@usuario]
                end

                def set_usuario
                @usuario = usuario.find(params[:id])
                end

                #Le coloco los parametros que necesito de la usuario para crearla y actualizarla
                def usuario_params
                    params.require(:usuario).permit(:zona_id, :concepto_id, :plan_id, :valor, :estado, 
                    :usuario)
                end 
        end
    end
end