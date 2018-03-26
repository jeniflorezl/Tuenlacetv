module Api
    module V1
        class TipoFacturacionController < ApplicationController
            before_action :set_tipo_facturacion_buscar, only: [:show]
            before_action :set_tipo_facturacion, only: [:update, :destroy]
  
            # GET /tipo_facturaciones
            def index
                @tipo_facturacion = TipoFacturacion.all
            end
        
            # GET /tipo_facturaciones/id
            def show
            end
        
            # POST /tipo_facturaciones
            def create
                @tipo_facturacion = TipoFacturacion.new(tipo_facturacion_params)
                if @tipo_facturacion.save 
                    render json: { status: :created }
                else
                    render json: @tipo_facturacion.errors, status: :unprocessable_entity
                end
            end
        
            # PATCH/PUT /tipo_facturaciones/id
            def update
                t = Time.now
                @tipo_facturacion.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                if @tipo_facturacion.update(tipo_facturacion_params)
                    render json: { status: :updated }
                else
                    render json: @tipo_facturacion.errors, status: :unprocessable_entity
                end
            end
        
            # DELETE /tipo_facturaciones/id
            def destroy
                if @tipo_facturacion
                    @tipo_facturacion.destroy
                    render json: { status: :deleted }
                  else
                    render json: { post: "not found" }
                  end
            end
        
            
            private

            # Me busca la tipo_facturacion por el id
            def set_tipo_facturacion
                @tipo_facturacion = TipoFacturacion.find(params[:id])
            end

            def set_tipo_facturacion_buscar
                campo = params[:campo]
                valor = params[:valor]
                if campo == 'id'
                  @tipo_facturacion = TipoFacturacion.find(valor)
                else
                  @tipo_facturacion = TipoFacturacion.limit(10).where("nombre LIKE '%#{valor}%'")
                end
                @tipo_facturacion = [*@tipo_facturacion]
            end

            #Le coloco los parametros que necesito del tipo_facturacion para crearla y actualizarla

            def tipo_facturacion_params
                params.require(:tipo_facturacion).permit(:nombre, :usuario_id)
            end 
        end
    end
end