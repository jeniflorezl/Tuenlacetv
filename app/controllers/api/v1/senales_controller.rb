module Api
    module V1
        class SenalesController < ApplicationController
            before_action :set_senal_buscar, only: [:show]
            before_action :set_senal, only: [:update, :destroy]

            @t = Time.now
            # GET /senales
            def index
                @senales = Senal.all
                @servicios = Servicio.all
                @barrios = Barrio.all
                @zonas = Zona.all
                @planes_tv = Plan.where(servicio_id: 1)
                @planes_int = Plan.where(servicio_id: 2)
                @tarifas = Tarifa.where(estado_id: 1)
                @tipo_instalaciones = TipoInstalacion.all
                @tecnologias = Tecnologia.all
                @tipo_documentos = TipoDocumento.all
                @funciones = Funcion.all
                @estados = Estado.all
                @vendedores = Entidad.where(funcion_id: 5)
                @tecnicos = Entidad.where(funcion_id: 7)
                @entidades = Entidad.all
                @plantillas = PlantillaFact.all
                @info_internet = InfoInternet.all
            end

            # GET /senales/id
            # GET /senales/documento
            # GET /senales/nombre1
            # GET /senales/nombre2
            # GET /senales/apellido1
            # GET /senales/apellido2
            # GET /senales/direccion
            # GET /senales/barrio
            # GET /senales/zona
            # GET /senales/telefono1
            # GET /senales/funcion
            # GET /senales/estado
            def show
            end

            # POST /senales
            def create
                @funcion = params[:funcion_id]
                @persona = Persona.new(persona_params)
                if @persona.save
                    @entidad = Entidad.new(funcion_id: @funcion, persona_id: @persona.id, usuario_id: @persona.usuario_id)
                    if @entidad.save and @funcion==1
                        @senal = Senal.new(senal_params)
                        @senal.entidad_id = @entidad.id
                        if @senal.save
                            if Senal.proceso_afiliacion(@senal, params[:tv], params[:internet], 
                            params[:valorafi_tv], params[:valorafi_int], params[:tarifa_id_tv], 
                            params[:tarifa_id_int])
                                render json: { status: :created }
                            else
                                render json: { error: "Error en proceso de afiliacion" }
                            end
                        else
                            render json: @senal.errors, status: :unprocessable_entity
                        end
                    end
                end
            end

            # PATCH/PUT /senales/id
            def update
                @senal.fechacam = @t.strftime("%d/%m/%Y %H:%M:%S")
                @persona.fechacam = @t.strftime("%d/%m/%Y %H:%M:%S")
                if @persona.update(persona_params)
                    if @senal.update(senal_params)
                        if params[:internet]==1
                            @info_internet.update(internet_params)
                        end
                        render json: { status: :updated }
                    else
                        render json: @senal.errors, status: :unprocessable_entity
                    end
                end
            end

            # DELETE /senales/id
            def destroy
                if @senal
                    @senal.destroy()
                    render json: { status: :deleted }
                else
                    render json: { post: "not found" }
                end
            end

            private

            def set_senal
                @entidad = Entidad.find(params[:id])
                @senal = Senal.find_by(entidad_id: @entidad.id)
                @persona = Persona.find(@entidad.persona_id)
                @info_internet = InfoInternet.find_by(senal_id: @senal.id)
            end
            
            # Me busca la senal por cualquier campo
            def set_senal_buscar
                @campo = params[:campo]
                @valor = params[:valor]
                query = <<-SQL 
                SELECT TOP(10) * FROM VwSenales WHERE #{@campo} LIKE '%#{@valor}%';
                SQL
                @senal = ActiveRecord::Base.connection.select_all(query)
                @senal = [*@senal]
                @entidad = Array.new
                @senal.each do |s|
                    @entidad = s["codigo"].to_i
                end
                @entidad = [*@entidad]
                @info_internet = InfoInternet.all
                @senales = Senal.all
            end


            #Le coloco los parametros que necesito de la persona y la señal para actualizarlos

            def senal_params
                params.require(:senal).permit(:contrato, :direccion, :urbanizacion, 
                :torre, :apto, :barrio_id, :zona_id, :telefono1, :telefono2, :contacto, :estrato,
                :vivienda, :observacion, :fechacontrato, :permanencia, :televisores,  
                :decos, :precinto, :vendedor_id, :tipo_instalacion_id, :tecnologia_id,
                :tiposervicio,:areainstalacion, :usuario_id)
            end 

            def persona_params
                params.require(:persona).permit(:tipo_documento_id, :documento, :nombre1, :nombre2, 
                :apellido1, :apellido2, :direccion, :barrio_id, :zona_id, :telefono1, :telefono2,  
                :correo, :fechanac, :tipopersona, :estrato, :condicionfisica, :usuario_id)
            end

            def internet_params
                params.require(:info_internet).permit(:direccionip, :velocidad, :mac1, :mac2, 
                :serialm, :marcam, :mascarasub, :dns, :gateway, :nodo, :clavewifi, :equipo, 
                :usuario_id)
            end
        end
    end
end