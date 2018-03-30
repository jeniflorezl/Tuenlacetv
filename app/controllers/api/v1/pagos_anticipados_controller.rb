module Api
    module V1
        class pago_anticipadosAnticipadosController < ApplicationController
            before_action :set_pago_anticipado_buscar, only: [:show]
            before_action :set_pago_anticipado, only: [:update, :anular, :anular_pago_anticipado_ant]

            # GET /pagos_anticipados
            def index
                query = <<-SQL 
                SELECT * FROM Vwpago_anticipadosAnticipados;
                SQL
                @pagos_anticipados = ActiveRecord::Base.connection.select_all(query)
                @documentos = Documento.all
                @formas_pago_anticipado = Formapago_anticipado.all
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
            def anular_pago_anticipado
                if @pago_anticipado
                    query = <<-SQL 
                    UPDATE pagos set valor = 0, estado_id = 7, observacion = 'ANULADO' WHERE id = #{@pago_anticipado[0]["id"]}
                    SQL
                    ActiveRecord::Base.connection.select_all(query)
                    render json: { status: :deleted }
                else
                    render json: { post: "not found" }
                end
            end

            private

            def set_pago_anticipado
                query = <<-SQL 
                SELECT * FROM pago_anticipados WHERE id=#{params[:id]};
                SQL
                ActiveRecord::Base.connection.clear_query_cache
                @pago_anticipado = ActiveRecord::Base.connection.select_all(query)
            end
            
            # Me busca el pago_anticipado por cualquier campo
            def set_pago_anticipado_buscar
                campo = params[:campo]
                valor = params[:valor]
                query = <<-SQL 
                SELECT * FROM VwPagosAnticipados WHERE #{campo} LIKE '%#{valor}%';
                SQL
                ActiveRecord::Base.connection.clear_query_cache
                @pago_anticipado = ActiveRecord::Base.connection.select_all(query)
                @pago_anticipado = [*@pago_anticipado]
            end
        end
    end
end