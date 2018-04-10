module Api
    module V1
        class PagosAnticipadosController < ApplicationController
            before_action :set_pago_anticipado_buscar, only: [:show]
            before_action :set_pago_anticipado, only: [:update, :anular, :anular_pago_anticipado]

            # GET /pagos_anticipados
            def index
                query = <<-SQL 
                SELECT * FROM VwPagosAnticipados;
                SQL
                @pagos_anticipados = Pago.connection.select_all(query)
                @documentos = Documento.all
                @formas_pago_anticipado = FormaPago.all
                @bancos = Banco.all
            end
            
            # POST /pagos_anticipados
            def create
                if Pago.generar_pago_anticipado(params[:entidad_id], params[:documento_id], params[:fechatrn],
                    params[:fechapxa], params[:cuotas], params[:valor], params[:observacion], params[:forma_pago_anticipado_id],
                    params[:banco_id], params[:cobrador_id], params[:detalle], params[:usuario_id])
                    render json: { status: :created }
                else
                    render json: { error: "Error en proceso" }
                end
            end

            # POST /pagos_anticipados/id
            def anular
                if @pago_anticipado
                    if Pago.anular_pago_anticipado(@pago[0]["id"])
                        render json: { status: :deleted }
                    else
                        render json: { error: "error al anular pago anticipado" }
                    end
                else
                    render json: { error: "not found" }
                end
            end

            private

            def set_pago_anticipado
                query = <<-SQL 
                SELECT * FROM VwPagosAnticipados WHERE id=#{params[:id]};
                SQL
                Pago.connection.clear_query_cache
                @pago_anticipado = Pago.connection.select_all(query)
            end
            
            # Me busca el pago_anticipado por cualquier campo
            def set_pago_anticipado_buscar
                campo = params[:campo]
                valor = params[:valor]
                query = <<-SQL 
                SELECT * FROM VwPagosAnticipados WHERE #{campo} LIKE '%#{valor}%';
                SQL
                Pago.connection.clear_query_cache
                @pago_anticipado = Pago.connection.select_all(query)
                @pago_anticipado = [*@pago_anticipado]
            end
        end
    end
end