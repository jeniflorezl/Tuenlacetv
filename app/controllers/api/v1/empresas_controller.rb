module Api
    module V1
        class EmpresasController < ApplicationController
            before_action :set_empresa_buscar, only: [:show]
            before_action :set_empresa, only: [:update, :destroy]

            # GET /empresas
            def index
                @empresas = Empresa.all
                @ciudades = Ciudad.all
                @personas = Persona.all
                @entidades = Entidad.all
            end

            # GET /empresas/id
            # GET /empresas/nit
            # GET /empresas/razon social
            def show
            end

            # POST /empresas
            def create
                @empresa = Empresa.new(empresa_params)
                if @empresa.save 
                    render json: { status: :created }
                else
                    render json: @empresa.errors, status: :unprocessable_entity
                end
            end

            # PATCH/PUT /empresas/id
            def update
                t = Time.now
                @empresa.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                if @empresa.update(empresa_params)
                    render json: { status: :updated }
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
                @campo = params[:campo]
                @valor = params[:valor]
                if @campo == 'codigo'
                    @empresa = Empresa.find(params[:valor])
                else
                    @empresa = Empresa.limit(10).where("#{@campo} LIKE '%#{@valor}%'")
                end
                @empresa = [*@empresa]
            end


            #Le coloco los parametros que necesito del empresa para crearlo y actualizarlo

            def empresa_params
                params.require(:empresa).permit(:tipo, :nit, :razonsocial, :direccion, :telefono1,
                :telefono2, :ciudad_id, :entidad_id, :logoempresa, :correo, :regimen, :contribuyente, 
                :centrocosto, :usuario_id)
            end 
        end
    end
end