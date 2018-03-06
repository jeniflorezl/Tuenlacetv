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
                result=0
                result1=0
                @funcion = params[:funcion_id]
                @persona = Persona.new(persona_params)
                if @persona.save
                    @entidad = Entidad.new(funcion_id: @funcion, persona_id: @persona.id, usuario_id: @persona.usuario_id)
                    if @entidad.save and @funcion==1
                        if (params[:tv] == 1)
                            @senal = Senal.new(senal_params)
                            @senal.entidad_id = @entidad.id
                            if @senal.save
                                if Senal.proceso_afiliacion_tv(@senal, @entidad, params[:valorafi_tv], 
                                    params[:tarifa_id_tv], params[:tecnico_id])
                                    result=1
                                else
                                    result=2
                                end
                            end
                        end
                        if (params[:internet] == 1)
                            @info_internet = InfoInternet.new(internet_params)
                            @info_internet.senal_id = @senal.id
                            if @info_internet.save
                                if Senal.proceso_afiliacion_int(@senal, @entidad, params[:valorafi_int], 
                                    params[:tarifa_id_int], params[:tecnico_id])
                                    result1=1
                                else
                                    result1=2
                                end
                            end
                        end
                        if (params[:tv]==1)
                            if (result == 1)
                                message1 = "creado servicio tv"
                            else
                                message1 = @senal.errors
                            end
                        end
                        if (params[:internet]==1)
                            if (result1 == 1)
                                message2 = "creado servicio internet"
                            else
                                message2 = @info_internet.errors
                            end
                        end
                        msg = message1 + ' ' + message2
                        #byebug
                        render :json => {:message => msg}.to_json
                        #render :json { 'message' => msg }
                    end
                else
                    render json: { error: "Ya existe un suscriptor con esa información" }
                end
            end

            # PATCH/PUT /senales/id
            def update
                @persona.fechacam = @t.strftime("%d/%m/%Y %H:%M:%S")
                if @persona.update(persona_params)
                    @senal.fechacam = @t.strftime("%d/%m/%Y %H:%M:%S")
                    if @senal.update(senal_params)
                        if (params[:tv] == 1)
                            unless @plantilla_tv
                                if Senal.proceso_afiliacion_tv(@senal, @entidad, params[:valorafi_tv], 
                                    params[:tarifa_id_tv], params[:tecnico_id])
                                    result=1
                                else
                                    result=2
                                end
                            end  
                        end
                        if params[:internet]==1
                            if @info_internet
                                @info_internet.fechacam = @t.strftime("%d/%m/%Y %H:%M:%S")
                                @info_internet.update(internet_params)
                            else
                                @info_internet = InfoInternet.new(internet_params)
                                @info_internet.senal_id = @senal.id
                                if @info_internet.save
                                    if Senal.proceso_afiliacion_int(@senal, @entidad, params[:valorafi_int], 
                                        params[:tarifa_id_int], params[:tecnico_id])
                                        result1=1
                                    else
                                        result1=2
                                    end
                                end
                            end
                        end
                    end
                end
                if (params[:tv]==1)
                    if (result == 1)
                        message1 = "actualizado servicio tv"
                    else
                        message1 = @senal.errors
                    end
                end
                if (params[:internet]==1)
                    if (result1 == 1)
                        message2 = "actualizado servicio internet"
                    else
                        message2 = @info_internet.errors
                    end
                end
                msg = message1 + ' ' + message2
                render :json => {:message => msg}.to_json
            end

            # DELETE /senales/id
            def destroy
                if @senal
                    @pago = Pago.find_by(entidad_id: @entidad.id).first
                    @factura = Facturacion.find_by(entidad_id: @entidad.id).first
                    if @pago or @factura
                        render json: { error: "El suscriptor no se puede eliminar" }
                    else
                        @senal.destroy()
                        render json: { status: :deleted }
                    end
                else
                    render json: { post: "not found" }
                end
            end

            private

            def set_senal
                @entidad = Entidad.find(params[:id])
                @persona = Persona.find(@entidad.persona_id)
                @senal = Senal.find_by(entidad_id: @entidad.id)
                @plantilla_tv = PlantillaFact.where("senal_id = ? AND concepto_id = ?", @senal.id, 3)
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