module Api
    module V1
        class PagosAnticipadosController < ApplicationController
            before_action :set_pago_anticipado_buscar, only: [:show]
            before_action :set_pago_anticipado, only: [:update, :anular, :anular_pago_anticipado]

            # GET /pagos_anticipados
            def index
                query = <<-SQL 
                SELECT * FROM VwPagosAnticipados ORDER BY id;
                SQL
                @pagos_anticipados = Pago.connection.select_all(query)
                @param_cobradores = Parametro.find_by(descripcion: 'Maneja cobradores').valor
            end

            def index_info
                @servicios = Servicio.all
                @documentos = Documento.where(abreviatura: 'REC')
                @cobradores = Entidad.where(funcion_id: 8)
                @param_cobradores = Parametro.find_by(descripcion: 'Maneja cobradores').valor
                @formas_pago = FormaPago.all
                @bancos = Banco.all
            end
            
            # POST /pagos_anticipados
            def create
                respuesta = 0
                respuesta = Pago.generar_pago_anticipado(params[:entidad_id], params[:documento_id], params[:servicio_id],
                    params[:fechatrn], params[:fechapxa], params[:valor], params[:descuento], params[:observacion], 
                    params[:forma_pago_id], params[:banco_id], params[:cobrador_id], params[:usuario_id])
                case respuesta
                when 1
                    render json: { status: :created }
                when 2
                    render json: { error: "no se pudo crear" }
                else
                    render json: { error: "cliente saldo 0" }
                end
            end

            # POST /pagos_anticipados/id
            def anular
                if @pago_anticipado
                    if Pago.anular_pago_anticipado(@pago_anticipado)
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