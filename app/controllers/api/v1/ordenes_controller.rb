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
                @conceptos = Concepto.where(clase: 'O')
                @tecnicos = Entidad.where(funcion_id: 7)
                @empleados = Entidad.where(funcion_id: 2)
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

            # DELETE /ordens/id
            def destroy
                if @orden
                    @orden.destroy()
                    render json: { status: :deleted }
                else
                    render json: { post: "not found" }
                end
            end

            private

            def set_orden
                @orden = orden.find(params[:id])
            end

            # Me busca la orden por el id o el nombre
            def set_orden_buscar
                campo = params[:campo]
                valor = params[:valor]
                if @campo == 'id'
                    @orden = orden.find(valor)
                else
                    @orden = orden.where("nombre LIKE '%#{valor}%'")
                end
                @orden = [*@orden]
            end
                
            #Le coloco los parametros que necesito de la orden para crearla y actualizarla

            def orden_params
                params.require(:orden).permit(:ciudad_id, :nombre, :usuario_id)
            end 
        end
    end
end
