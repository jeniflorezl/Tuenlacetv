module Api
    module V1
        class PagosController < ApplicationController
            before_action :set_empresa_buscar, only: [:show]
            before_action :set_empresa, only: [:update, :destroy]

            # GET /pagos
            def index
                query = <<-SQL 
                SELECT * FROM pagos;
                SQL
                @pagos = ActiveRecord::Base.connection.select_all(query)
                @documentos = Documento.all
                @formas_pago = FormaPago.all
                @bancos = Banco.all
            end

            def index_pago
                @detalle_facts = Pago.detalle_facturas(params[:entidad_id])
            end

            
            # POST /pagos
            def create
                if Pago.generar_pago(params[:entidad_id], params[:documento_id], params[:fechatrn],
                    params[:fechaven], params[:valor], params[:observacion], params[:forma_pago_id],
                    params[:banco_id], params[:cobrador_id], params[:detalle], params[:usuario_id])
                    render json: { status: :created }
                else
                    render json: { error: "Error en proceso" }
                end
            end

            # POST /pagos/id
            def anular
                if @pago
                    query = <<-SQL 
                    UPDATE pagos set valor = 0, estado_id = 7, observacion = 'ANULADO' WHERE id = #{@pago[0]["id"]}
                    SQL
                    ActiveRecord::Base.connection.select_all(query)
                    render json: { status: :deleted }
                else
                    render json: { post: "not found" }
                end
            end

            private

            def set_pago
                query = <<-SQL 
                SELECT * FROM pagos WHERE id=#{params[:id]};
                SQL
                ActiveRecord::Base.connection.clear_query_cache
                @pago = ActiveRecord::Base.connection.select_all(query)
            end
            
            # Me busca el pago por cualquier campo
            def set_pago_buscar
                campo = params[:campo]
                valor = params[:valor]
                query = <<-SQL 
                SELECT * FROM pagos WHERE #{campo} LIKE '%#{valor}%';
                SQL
                ActiveRecord::Base.connection.clear_query_cache
                @pago = ActiveRecord::Base.connection.select_all(query)
                @pago = [*@pago]
            end
        end
    end
end