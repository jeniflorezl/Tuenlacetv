module Api
    module V1
        class FacturacionController < ApplicationController
            before_action :set_ciudad_buscar, only: [:show]
            before_action :set_ciudad, only: [:update, :destroy]
  
            # GET /facturaciones
            def index
                @facturaciones = Facturacion.facturaciones_generadas
            end

            def info_fact_manual
                @tipo_facturacion = TipoFacturacion.all
                @zonas = Zona.all
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

            def generar_facturacion
                @filename = 'my_report.pdf'
                @documentos = Documento.all
            end
        end
    end
end