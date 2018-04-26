module Api
    module V1
        class SenalesController < ApplicationController
            before_action :set_senal_buscar, only: [:show]
            before_action :set_entidad_buscar, only: [:show_entidad]
            before_action :set_senal, only: [:update, :destroy]

            # GET /senales
            def index
                @funcion = params[:funcion_id]
                query = <<-SQL 
                SELECT * FROM VwSenales WHERE funcion_id = #{@funcion} ORDER BY id;
                SQL
                @entidades = Senal.connection.select_all(query)
                @tipo_documentos = TipoDocumento.all
                @barrios = Barrio.all
                @zonas = Zona.all
                @ciudades = Ciudad.all
                @funciones = Funcion.all
                if @funcion == "1"
                    @servicios = Servicio.all
                    @planes_tv = Plan.where(servicio_id: 1)
                    @planes_int = Plan.where(servicio_id: 2)
                    @tarifas = Tarifa.where(estado_id: 1)
                    @valor_afi_tv = Tarifa.find_by(concepto_id: 1).valor
                    @valor_afi_int = Tarifa.find_by(concepto_id: 2).valor
                    @param_valor_afi = Parametro.find_by(descripcion: 'Permite modificar valor de afiliación').valor
                    @tipo_instalaciones = TipoInstalacion.all
                    @tecnologias = Tecnologia.all
                    @vendedores = Entidad.where(funcion_id: 5)
                    @tecnicos = Entidad.where(funcion_id: 7)
                    @tipo_facturacion = TipoFacturacion.all
                end
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
                message1 = ''
                message2 = ''
                msg = ''
                funcion = params[:funcion_id]
                @persona = Persona.new(persona_params)
                if @persona.save
                    if funcion != "1"
                        query = <<-SQL 
                        SELECT MAX(id) as ultimo FROM entidades WHERE id>=50000;
                        SQL
                        Senal.connection.clear_query_cache
                        ultimo = Senal.connection.select_all(query)
                        if ultimo[0]["ultimo"] == nil
                            ultimo = 50000
                        else
                            ultimo = (ultimo[0]["ultimo"]).to_i + 1
                        end
                    else
                        query = <<-SQL 
                        SELECT MAX(id) as ultimo FROM entidades WHERE id<50000;
                        SQL
                        Senal.connection.clear_query_cache
                        ultimo = Senal.connection.select_all(query)
                        if ultimo[0]["ultimo"] == nil
                            ultimo = 1
                        else
                            ultimo = (ultimo[0]["ultimo"]).to_i + 1
                        end
                    end
                    @entidad = Entidad.new(id: ultimo, funcion_id: funcion, persona_id: @persona.id, usuario_id: @persona.usuario_id)
                    if @entidad.save 
                        if funcion == "1"
                            @senal = Senal.new(senal_params)
                            @senal.entidad_id = @entidad.id
                            if @senal.save
                                if params[:tv] == 1
                                    if Senal.afiliacion_tv(@senal, @entidad, params[:valorafi_tv], 
                                        params[:valor_dcto_tv], params[:tarifa_id_tv], params[:tecnico_id])
                                        result = 1
                                    else
                                        result = 2
                                    end
                                end
                                if params[:internet] == 1
                                    @info_internet = InfoInternet.new(internet_params)
                                    @info_internet.entidad_id = @entidad.id
                                    if @info_internet.save
                                        if Senal.afiliacion_int(@senal, @entidad, params[:valorafi_int], 
                                            params[:valor_dcto_int],params[:tarifa_id_int], params[:tecnico_id])
                                            result1 = 1
                                        else
                                            result1 = 2
                                        end
                                    end
                                end
                            end
                            if params[:tv] == 1
                                if result == 1
                                    message1 = "creado servicio tv"
                                else
                                    message1 = @senal.errors
                                end
                            end
                            if params[:internet] == 1
                                if result1 == 1
                                    message2 = "creado servicio internet"
                                else
                                    message2 = @info_internet.errors
                                end
                            end
                            render :json => {:message1 => message1,
                                :message2 => message2 }.to_json
                        else
                            render json: { error: "Persona creada con exito" }
                        end
                    end
                else
                    render json: { error: "Ya existe un suscriptor con esa información" }
                end
            end

            # PATCH/PUT /senales/id
            def update
                result=0
                result1=0
                message1 = ''
                message2 = ''
                t = Time.now
                @persona.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                if @persona.update(persona_params)
                    @senal.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                    if @senal.update(senal_params)
                        if params[:tv] == 1
                            if @plantilla_tv.blank?
                                if Senal.afiliacion_tv(@senal, @entidad, params[:valorafi_tv], 
                                    params[:valor_dcto_tv], params[:tarifa_id_tv], params[:tecnico_id])
                                    result = 1
                                else
                                    result = 2
                                end
                            else
                                @plantilla_tv.update(tarifa_id: params[:tarifa_id_tv])
                                result = 1
                            end 
                        else
                            result = 1
                        end
                        if params[:internet] == 1
                            if @info_internet
                                @info_internet.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                                @info_internet.update(internet_params)
                                if @plantilla_int.blank?
                                    if Senal.afiliacion_int(@senal, @entidad, params[:valorafi_int], 
                                        params[:valor_dcto_int],params[:tarifa_id_int], params[:tecnico_id])
                                        result1 = 1
                                    else
                                        result1 = 2
                                    end
                                else
                                    @plantilla_int.update(tarifa_id: params[:tarifa_id_int])
                                    result1 = 1
                                end
                            else
                                @info_internet = InfoInternet.new(internet_params)
                                @info_internet.entidad_id = @entidad.id
                                if @info_internet.save
                                    if Senal.afiliacion_int(@senal, @entidad, params[:valorafi_int], 
                                        params[:valor_dcto_int],params[:tarifa_id_int], params[:tecnico_id])
                                        result1 = 1
                                    else
                                        result1 = 2
                                    end
                                end
                            end
                        else
                            result1=1
                        end
                    end
                    if params[:tv] == 1
                        if result == 1
                            message1 = "actualizado servicio tv"
                        else
                            message1 = @senal.errors
                        end
                    end
                    if params[:internet] == 1
                        if result1 == 1
                            message2 = "actualizado servicio internet"
                        else
                            message2 = @info_internet.errors
                        end
                    end
                    render :json => {:message1 => message1,
                    :message2 => message2 }.to_json
                else
                    render json: { error: "Informacion persona" }
                end
            end

            # DELETE /senales/id
            def destroy
                if @senal
                    if Senal.eliminar_suscriptor(@entidad, @persona, @senal, @info_internet, 
                        @plantilla_tv, @plantilla_int)
                        render json: { status: :deleted }
                    else
                        render json: { error: "El suscriptor no se puede eliminar" }
                    end
                else
                    render json: { post: "not found" }
                end
            end

            def listado_consolidado
                query = <<-SQL 
                SELECT * FROM VwSenales WHERE funcion_id = 1;
                SQL
                @senal = Senal.connection.select_all(query)
                query = <<-SQL 
                SELECT * FROM VwOrdenes WHERE concepto_id = 11 or concepto_id = 12;
                SQL
                @instalaciones = Senal.connection.select_all(query)
                query = <<-SQL 
                SELECT * FROM VwOrdenes WHERE concepto_id = 7 or concepto_id = 8;
                SQL
                @cortes = Senal.connection.select_all(query)
                query = <<-SQL 
                SELECT * FROM VwOrdenes WHERE concepto_id = 13 or concepto_id = 14;
                SQL
                @traslados = Senal.connection.select_all(query)
                query = <<-SQL 
                SELECT * FROM VwOrdenes WHERE concepto_id = 15 or concepto_id = 16;
                SQL
                @reconexiones = Senal.connection.select_all(query)
            end

            def listado_television
                query = <<-SQL 
                SELECT * FROM VwSenales WHERE funcion_id = 1 and tv = 1;
                SQL
                @senal = Senal.connection.select_all(query)
                query = <<-SQL 
                SELECT * FROM VwOrdenes WHERE concepto_id = 11;
                SQL
                @instalaciones = Senal.connection.select_all(query)
                query = <<-SQL 
                SELECT * FROM VwOrdenes WHERE concepto_id = 7;
                SQL
                @cortes = Senal.connection.select_all(query)
                query = <<-SQL 
                SELECT * FROM VwOrdenes WHERE concepto_id = 13;
                SQL
                @traslados = Senal.connection.select_all(query)
                query = <<-SQL 
                SELECT * FROM VwOrdenes WHERE concepto_id = 15;
                SQL
                @reconexiones = Senal.connection.select_all(query)
            end

            def listado_internet
                query = <<-SQL 
                SELECT * FROM VwSenales WHERE funcion_id = 1 and internet = 1;
                SQL
                @senal = Senal.connection.select_all(query)
                query = <<-SQL 
                SELECT * FROM VwOrdenes WHERE concepto_id = 12;
                SQL
                @instalaciones = Senal.connection.select_all(query)
                query = <<-SQL 
                SELECT * FROM VwOrdenes WHERE concepto_id = 8;
                SQL
                @cortes = Senal.connection.select_all(query)
                query = <<-SQL 
                SELECT * FROM VwOrdenes WHERE concepto_id = 14;
                SQL
                @traslados = Senal.connection.select_all(query)
                query = <<-SQL 
                SELECT * FROM VwOrdenes WHERE concepto_id = 16;
                SQL
                @reconexiones = Senal.connection.select_all(query)
            end

            private

            def set_senal
                @entidad = Entidad.find(params[:id])
                @persona = Persona.find(@entidad.persona_id)
                @senal = Senal.find_by(entidad_id: @entidad.id)
                @info_internet = InfoInternet.find_by(entidad_id: @entidad.id)
                @plantilla_tv = PlantillaFact.where("entidad_id = ? AND concepto_id = ?", @entidad.id, 3)
                @plantilla_int = PlantillaFact.where("entidad_id = ? AND concepto_id = ?", @entidad.id, 4)
            end
            
            # Me busca la senal por cualquier campo
            def set_senal_buscar
                funcion_id = params[:funcion_id]
                campo = params[:campo]
                valor = params[:valor]
                query = <<-SQL 
                SELECT * FROM VwSenales WHERE #{campo} LIKE '%#{valor}%' and funcion_id = #{funcion_id};
                SQL
                @entidad = Senal.connection.select_all(query)
                @entidad = [*@entidad]
                @info_internet = InfoInternet.all
                @senales = Senal.all
                @plantillas_tv = PlantillaFact.where(concepto_id: 3)
                @plantillas_int = PlantillaFact.where(concepto_id: 4)
                query = <<-SQL 
                SELECT * FROM VwEstadoDeCuentaTotal;
                SQL
                Senal.connection.clear_query_cache
                @saldos = Senal.connection.select_all(query)
            end

            #Le coloco los parametros que necesito de la persona y la señal para actualizarlos

            def senal_params
                params.require(:senal).permit(:contrato, :direccion, :urbanizacion, 
                    :torre, :apto, :barrio_id, :zona_id, :telefono1, :telefono2, :contacto, :estrato,
                    :vivienda, :observacion, :fechacontrato, :permanencia, :televisores,  
                    :decos, :precinto, :vendedor_id, :tipo_instalacion_id, :tecnologia_id,
                    :tiposervicio, :areainstalacion, :usuario_id, :tipo_facturacion_id)
            end 

            def persona_params
                params.require(:persona).permit(:tipo_documento_id, :documento, :nombre1, :nombre2, 
                    :apellido1, :apellido2, :direccion, :barrio_id, :zona_id, :ciudad_id, :telefono1, 
                    :telefono2, :correo, :fechanac, :tipopersona, :estrato, :condicionfisica, :usuario_id)
            end

            def internet_params
                params.require(:info_internet).permit(:direccionip, :velocidad, :mac1, :mac2, 
                    :serialm, :marcam, :mascarasub, :dns, :gateway, :nodo, :clavewifi, :equipo, 
                    :usuario_id)
            end
        end
    end
end