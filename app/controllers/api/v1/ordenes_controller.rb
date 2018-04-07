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
            end

            # GET /ordens/id
            # GET /ordens/nombre
            def show
            end

            # POST /ordens
            def create
                @orden = orden.new(orden_params)
                if @orden.save 
                    render json: { status: :created }
                else
                    render json: @orden.errors, status: :unprocessable_entity
                end
            end

            # PATCH/PUT /ordens/id
            def update
                t = Time.now
                @orden.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                if @orden.update(orden_params)
                    render json: { status: :updated }
                else
                    render json: @orden.errors, status: :unprocessable_entity
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
