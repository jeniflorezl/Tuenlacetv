module Api
    module V1
        class FacturacionController < ApplicationController
            before_action :set_ciudad_buscar, only: [:show]
            before_action :set_ciudad, only: [:update, :destroy]
  
            # GET /facturaciones
            def index
                @facturaciones = Facturacion.facturaciones_generadas
            end
        
            # GET /facturaciones/id
            def show
            end

            # POST /facturaciones
            def create
                if Facturacion.generar_facturacion(params[:tipo_fact_id], params[:f_elaboracion], params[:f_inicio], 
                    params[:f_fin], params[:f_vence], params[:f_corte], params[:f_vencidos],
                    params[:observa], params[:zona], params[:usuario_id])
                    render json: { status: :created }
                else
                    render json: { error: "error en el proceso" }
                end
            end

            def create_factura
                if Facturacion.factura_manual(params[:tipo_facturacion_id], params[:servicio_id], 
                    params[:f_elaboracion], params[:f_inicio], params[:f_fin], params[:entidad_id], 
                    params[:valor], params[:observa], params[:usuario_id])
                    render json: { status: :created }
                else
                    render json: { error: "error en el proceso" }
                end
            end
        
            # PATCH/PUT /facturaciones/id
            def update
            t = Time.now
            @ciudad.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                if @ciudad.update(ciudad_params)
                    render json: { status: :updated }
                else
                    render json: @ciudad.errors, status: :unprocessable_entity
                end
            end
        
            # DELETE /facturaciones/id
            def destroy
                if @ciudad
                    @ciudad.destroy
                    render json: { status: :deleted }
                  else
                    render json: { post: "not found" }
                  end
            end
        
            
            private

            # Me busca la ciudad por el id
            def set_ciudad
                @ciudad = Ciudad.find(params[:id])
            end

            def set_ciudad_buscar
                @campo = params[:campo]
                @valor = params[:valor]
                if @campo == 'id'
                  @ciudad = Ciudad.find(params[:valor])
                else
                  @ciudad = Ciudad.limit(10).where("nombre LIKE '%#{@valor}%'")
                end
                @ciudad = [*@ciudad]
            end
        end
    end
end