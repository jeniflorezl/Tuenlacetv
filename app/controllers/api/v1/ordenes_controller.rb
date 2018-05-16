module Api
    module V1
        class OrdenesController < ApplicationController
            before_action :set_orden_buscar, only: [:show]
            before_action :set_orden, only: [:update, :destroy, :anular]

            # GET /ordenes
            def index
                query = <<-SQL 
                SELECT * FROM VwOrdenes ORDER BY id;
                SQL
                @ordenes = Orden.connection.select_all(query)
                @detalle_orden = DetalleOrden.all
                @grupos = Grupo.all
                @articulos = Articulo.all
                @param_instalacion = Parametro.find_by(descripcion: 'Pregunta si desea cobrar dias al editar instalacion').valor
                @param_corte = Parametro.find_by(descripcion: 'Pregunta si desea cobrar dias al editar corte').valor
                @param_rco = Parametro.find_by(descripcion: 'Pregunta si desea cobrar dias al editar reconexion').valor
                @param_retiro = Parametro.find_by(descripcion: 'Pregunta si desea cobrar dias al editar retiro').valor

            end

            # GET /info ordenes
            def index_info
                @conceptos = Concepto.where(clase: 'O')
                @tarifas = Tarifa.where(estado_id: 1)
                @tecnicos = Entidad.where(funcion_id: 7)
                @param_valor = Parametro.find_by(descripcion: 'Permite cambiar valor de ordenes').valor
                @meses_anteriores = Parametro.find_by(descripcion: 'Permite ordenes en meses anteriores').valor
                @meses_posteriores = Parametro.find_by(descripcion: 'Permite ordenes en meses posteriores').valor
            end

            # GET /ordens/id
            # GET /ordens/nombre
            def show
            end

            # POST /ordens
            def create
                respuesta = 0
                respuesta = Orden.generar_orden(params[:entidad_id], params[:concepto_id], params[:fechatrn], 
                    params[:fechaven], params[:valor], params[:observacion], params[:tecnico_id],
                    params[:zonaNue], params[:barrioNue], params[:direccionNue], params[:decos], 
                    params[:usuario_id])
                case respuesta
                when 1
                    render json: { status: :created }
                when 2
                    render json: { error: "no se pudo crear orden" }
                when 3
                    render json: { error: "estado erroneo" }
                end
            end

            # PATCH/PUT /ordenes/id
            def update
                if @orden.blank?
                    render json: { error: "not found" }
                else
                    if Orden.editar_orden(@orden, params[:fechaven], params[:solicita], params[:tecnico_id], 
                        params[:observacion], params[:detalle], params[:solucion], params[:respuesta], params[:usuario_id])
                        render json: { status: :updated }
                    else
                        render json: { error: "no se pudo actualizar orden" }
                    end
                end
            end

            # POST /ordenes/id
            def anular
                respuesta = 0
                if @orden
                    respuesta = Orden.anular_orden(@orden)
                    case respuesta
                    when 1
                        render json: { status: :anulada }
                    when 2
                        render json: { error: "no se pudo anular orden" }
                    when 3
                        render json: { error: "orden aplicada" }
                    when 4
                        render json: { error: "orden con pago" }
                    end
                else
                    render json: { error: "not found" }
                end
            end

            def listado_ordenes
                @listado = Orden.listado_ordenes(params[:fechaini], params[:fechafin])
            end

            private

            def set_orden
                query = <<-SQL 
                SELECT * FROM ordenes WHERE id=#{params[:id]};
                SQL
                Orden.connection.clear_query_cache
                @orden = Orden.connection.select_all(query)
            end

            # Me busca la orden por el id o el nombre
            def set_orden_buscar
                campo = params[:campo]
                valor = params[:valor]
                query = <<-SQL 
                SELECT * FROM VwOrdenes WHERE #{campo} LIKE '%#{valor}%';
                SQL
                @orden = Senal.connection.select_all(query)
                @orden = [*@orden]
            end
        end
    end
end
