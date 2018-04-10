module Api
    module V1
        class OrdenesController < ApplicationController
            before_action :set_orden_buscar, only: [:show]
            before_action :set_orden, only: [:update, :destroy]

            # GET /ordenes
            def index
                query = <<-SQL 
                SELECT * FROM VwOrdenes;
                SQL
                @ordenes = Orden.connection.select_all(query)
            end

            # GET /info ordenes
            def index_info
                @conceptos = Concepto.where(clase: 'O')
                @tarifas = Tarifa.where(estado_id: 1)
                @tecnicos = Entidad.where(funcion_id: 7)
                @empleados = Entidad.where(funcion_id: 2)
                @grupos = Grupo.all
                @articulos = Articulo.all
                @param_valor = Parametro.find_by(descripcion: 'Permite cambiar valor de ordenes').valor
                @meses_anteriores = Parametro.find_by(descripcion: 'Permite ordenes en meses anteriores').valor
                @meses_posteriores = Parametro.find_by(descripcion: 'Permire ordenes en meses posteriores').valor
            end

            # GET /ordens/id
            # GET /ordens/nombre
            def show
            end

            # POST /ordens
            def create
                if Orden.generar_orden(params[:entidad_id], params[:concepto_id], params[:fechatrn], 
                    params[:fechaven], params[:valor], params[:detalle], params[:observacion], 
                    params[:tecnico_id], params[:solicita], params[:zonaNue], params[:barrioNue], 
                    params[:direccionNue], params[:usuario_id])
                    render json: { status: :created }
                else
                    render json: { error: "no se pudo crear orden" }
                end
            end

            # PATCH/PUT /ordenes/id
            def update
                if @orden
                    if Orden.editar_orden(@orden, params[:fechaven], params[:solicita], params[:tecnico_id], 
                        params[:observacion], params[:detalle], params[:solucion], params[:usuario_id])
                        render json: { status: :updated }
                    else
                        render json: { error: "no se pudo actualizar orden" }
                    end
                else
                    render json: { error: "not found" }
                end
            end

            # POST /ordenes/id
            def anular
                if @orden
                    if Orden.anular_orden(@orden)
                        render json: { status: :updated }
                    else
                        render json: { error: "no se pudo actualizar orden" }
                    end
                else
                    render json: { error: "not found" }
                end
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
