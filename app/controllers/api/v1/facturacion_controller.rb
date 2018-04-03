module Api
    module V1
        class FacturacionController < ApplicationController
  
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
                respuesta = 0
                respuesta = Facturacion.generar_facturacion(params[:tipo_facturacion_id], params[:f_elaboracion], params[:f_inicio], 
                    params[:f_fin], params[:f_vence], params[:f_corte], params[:f_vencidos],
                    params[:observa], params[:zona], params[:usuario_id])
                case respuesta
                when 1
                    render json: { status: :created }
                when 2
                    render json: { error: "error en el proceso" }
                when 3
                    render json: { error: "ya generada" }
                else 4
                    render json: { error: "ya generada para esta zona" }
                end
            end

            def create_factura
                respuesta = 0
                respuesta = Facturacion.factura_manual(params[:tipo_facturacion_id], params[:servicio_id], 
                    params[:f_elaboracion], params[:f_inicio], params[:f_fin], params[:entidad_id], 
                    params[:valor], params[:observa], params[:usuario_id])
                case respuesta
                when 1
                    render json: { status: :created }
                when 2
                    render json: { error: "no se pudo crear" }
                when 3
                    render json: { error: "mes diferente al corriente" }
                else 4
                    render json: { error: "ya tiene factura en el mes corriente" }
                end
            end

            def anular_factura
                if Facturacion.anular_factura(params[:entidad_id], params[:nrodcto])
                    render json: { status: :anulada }
                else
                    render json: { error: "no se anulo factura" }
                end
            end

            def generar_facturacion
                @filename = 'my_report.pdf'
                @documentos = Documento.all
            end
        end
    end
end