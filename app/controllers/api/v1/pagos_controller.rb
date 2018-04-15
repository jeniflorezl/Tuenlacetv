module Api
    module V1
        class PagosController < ApplicationController
            before_action :set_pago_buscar, only: [:show]
            before_action :set_pago, only: [:update, :anular, :anular_pago_ant]

            # GET /pagos
            def index
                query = <<-SQL 
                SELECT * FROM VwPagos ORDER BY id;
                SQL
                @pagos = Pago.connection.select_all(query)
                @param_cobradores = Parametro.find_by(descripcion: 'Maneja cobradores').valor
            end

            def index_pago
                @detalle_facts = Pago.detalle_facturas(params[:entidad_id])
                @valor_total = Pago.valor_total(@detalle_facts)
                @documentos = Documento.where(clase: 'P')
                @cobradores = Entidad.where(funcion_id: 8)
                @param_cobradores = Parametro.find_by(descripcion: 'Maneja cobradores').valor
                @formas_pago = FormaPago.all
                @bancos = Banco.all
            end
            
            # POST /pagos
            def create
                if Pago.generar_pago(params[:entidad_id], params[:documento_id], params[:fechatrn],
                    params[:valor], params[:descuento], params[:observacion], params[:forma_pago_id],
                    params[:banco_id], params[:cobrador_id], params[:detalle], params[:usuario_id])
                    render json: { status: :created }
                else
                    render json: { error: "Error en proceso" }
                end
            end

            # POST /pagos/id
            def anular
                if @pago
                    if Pago.anular_pago(@pago[0]["id"])
                        render json: { status: :anulado }
                    else
                        render json: { error: "error al anular pago" }
                    end
                else
                    render json: { post: "not found" }
                end
            end

            private

            def set_pago
                query = <<-SQL 
                SELECT * FROM pagos WHERE id=#{params[:id]};
                SQL
                Pago.connection.clear_query_cache
                @pago = Pago.connection.select_all(query)
            end
            
            # Me busca el pago por cualquier campo
            def set_pago_buscar
                campo = params[:campo]
                valor = params[:valor]
                query = <<-SQL 
                SELECT * FROM pagos WHERE #{campo} LIKE '%#{valor}%';
                SQL
                Pago.connection.clear_query_cache
                @pago = ActiveRecord::Base.connection.select_all(query)
                @pago = [*@pago]
            end
        end
    end
end