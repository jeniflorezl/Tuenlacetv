module Api
    module V1
        class PagosController < ApplicationController
            before_action :set_empresa_buscar, only: [:show]
            before_action :set_empresa, only: [:update, :destroy]

            # GET /facturas
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
                @empresa = Empresa.new(empresa_params)
                @empresa.tipo = '01'
                if @empresa.save 
                    render json: { status: :created }
                else
                    render json: @empresa.errors, status: :unprocessable_entity
                end
            end

            # DELETE /empresas/id
            def destroy
                if @empresa
                    @empresa.destroy()
                    render json: { status: :deleted }
                else
                    render json: { post: "not found" }
                end
            end

            private

            def set_empresa
                @empresa = Empresa.find(params[:id])
                @entidades = Entidad.all
            end
            
            # Me busca el empresa por el id, la zona o el nombre
            def set_empresa_buscar
                campo = params[:campo]
                valor = params[:valor]
                if @campo == 'id'
                    @empresa = Empresa.find(valor)
                else
                    @empresa = Empresa.limit(10).where("#{campo} LIKE '%#{valor}%'")
                end
                @empresa = [*@empresa]
            end


            #Le coloco los parametros que necesito del empresa para crearlo y actualizarlo

            def empresa_params
                params.require(:empresa).permit(:nit, :razonsocial, :direccion, :telefono1,
                    :telefono2, :ciudad_id, :entidad_id, :logo, :correo, :regimen, :contribuyente, 
                    :centrocosto, :usuario_id)
            end 
        end
    end
end