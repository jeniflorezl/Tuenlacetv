module Api
    module V1
        class BancosController < ApplicationController
            before_action :set_banco_buscar, only: [:show]
            before_action :set_banco, only: [:update, :destroy]

            # GET /bancos
            def index
                @bancos = Banco.all
            end

            # GET /bancos/id
            # GET /bancos/nit
            # GET /bancos/nombre
            def show
            end

            # POST /bancos
            def create
                @banco = Banco.new(banco_params)
                if @banco.save 
                    render json: { status: :created }
                else
                    render json: @banco.errors, status: :unprocessable_entity
                end
            end

            # PATCH/PUT /bancos/id
            def update
                t = Time.now
                @banco.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                if @banco.update(banco_params)
                    render json: { status: :updated }
                else
                    render json: @banco.errors, status: :unprocessable_entity
                end
            end

            # DELETE /bancos/id
            def destroy
                if @banco
                    @banco.destroy()
                    render json: { status: :deleted }
                else
                    render json: { post: "not found" }
                end
            end

            private

            def set_banco
                @banco = Banco.find(params[:id])
            end
            
            # Me busca el banco por el id, la zona o el nombre
            def set_banco_buscar
                @campo = params[:campo]
                @valor = params[:valor]
                if @campo == 'codigo'
                    @banco = Banco.find(params[:valor])
                else
                    @banco = Banco.limit(10).where("#{@campo} LIKE '%#{@valor}%'")
                end
                @banco = [*@banco]
            end


            #Le coloco los parametros que necesito del banco para crearlo y actualizarlo

            def banco_params
                params.require(:banco).permit(:nit, :nombre, :direccion, :ciudad_id, :telefono1,
                :telefono2, :contacto, :cuentaBancaria, :cuentaContable, :usuario)
            end 
        end
    end
end