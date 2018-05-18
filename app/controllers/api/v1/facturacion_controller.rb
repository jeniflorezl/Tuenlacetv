module Api
    module V1
        class FacturacionController < ApplicationController
  
            # GET /facturaciones
            def index
                @facturaciones = Facturacion.facturaciones_generadas
            end

            def info_facturacion
                @tipo_facturacion = TipoFacturacion.all
                @zonas = Zona.all
                @fecha_corte = Parametro.find_by(descripcion: 'Maneja fecha corte servicio').valor
                @fecha_pagos_ven = Parametro.find_by(descripcion: 'Maneja fecha pagos vencidos').valor
            end

            def index_facturas
                @detalle_facts = Pago.detalle_facturas(params[:entidad_id])
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
                    params[:f_elaboracion], params[:f_inicio], params[:f_fin], params[:f_vencimiento],
                    params[:entidad_id], params[:valor], params[:valor2], params[:observa], params[:usuario_id])
                case respuesta
                when 1
                    render json: { status: :created }
                when 2
                    render json: { error: "no se pudo crear" }
                when 3
                    render json: { error: "mes diferente al corriente" }
                else 4
                    render json: { error: "valor mayor a la tarifa" }
                end
            end

            def anular_factura
                if Facturacion.anular_factura(params[:entidad_id], params[:concepto_id], params[:nrodcto])
                    render json: { status: :anulada }
                else
                    render json: { error: "no se anulo factura" }
                end
            end

            def listado_fras
                @listado = Facturacion.listado_fras_ventas(params[:fechaini], params[:fechafin])
            end

            def generar_facturacion
                @ciudad = Ciudad.first.nombre
                f_elaboracion = params[:f_elaboracion]
                f_inicio = params[:f_inicio]
                fecha_ini = Date.parse f_inicio
                @f_inicio_dia = fecha_ini.day
                @f_inicio_mes = fecha_ini.month
                @f_inicio_ano = fecha_ini.year
                f_fin = params[:f_fin]
                f_vencimiento = params[:f_vencimiento]
                fecha_ven = Date.parse f_vencimiento
                @f_ven_dia = fecha_ven.day
                @f_ven_mes = fecha_ven.month
                @f_ven_ano = fecha_ven.year
                fact_inicial = params[:fact_inicial]
                fact_final = params[:fact_final]
                saldo_inicial = params[:saldo_inicial]
                saldo_final = params[:saldo_final]
                @f_corte = params[:f_corte]
                @zona = params[:zona]
                Facturacion.impresion_facturacion(@zona, params[:tipo_fact], f_elaboracion, 
                    f_inicio, f_fin, f_vencimiento, fact_inicial, fact_final, saldo_inicial, saldo_final, 
                    @f_corte, params[:nota_1], params[:nota_2], params[:nota_3], params[:rango])
                query = <<-SQL 
                SELECT * FROM VwSenales WHERE funcion_id = 1 ORDER BY id;
                SQL
                @senales = Facturacion.connection.select_all(query)
                query = <<-SQL 
                SELECT * FROM VwImpresionFacturacion ORDER BY entidad_id;
                SQL
                @facturas = Facturacion.connection.select_all(query)
            end
        end
    end
end