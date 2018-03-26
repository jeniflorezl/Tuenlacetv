module Api
    module V1
        class CiudadesController < ApplicationController
            before_action :set_ciudad_buscar, only: [:show]
            before_action :set_ciudad, only: [:update, :destroy]
  
            # GET /ciudades
            def index
                @ciudades = Ciudad.all
                @paises = Pais.all
                @departamentos = Departamento.all
            end
        
            # GET /ciudades/id
            def show
            end
        
            # POST /ciudades
            def create
                @ciudad = Ciudad.new(ciudad_params)
                if @ciudad.save 
                    render json: { status: :created }
                else
                    render json: @ciudad.errors, status: :unprocessable_entity
                end
            end
        
            # PATCH/PUT /ciudades/id
            def update
                t = Time.now
                @ciudad.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                if @ciudad.update(ciudad_params)
                    render json: { status: :updated }
                else
                    render json: @ciudad.errors, status: :unprocessable_entity
                end
            end
        
            # DELETE /ciudades/id
            def destroy
                if @ciudad
                    @ciudad.destroy
                    render json: { status: :deleted }
                else
                    render json: { post: "not found" }
                end
            end
        
            
            private

            # Me busca la ciudad por el id
            def set_ciudad
                @ciudad = Ciudad.find(params[:id])
            end

            def set_ciudad_buscar
                campo = params[:campo]
                valor = params[:valor]
                if campo == 'id'
                  @ciudad = Ciudad.find(valor)
                else
                  @ciudad = Ciudad.limit(10).where("nombre LIKE '%#{valor}%'")
                end
                @ciudad = [*@ciudad]
            end

            #Le coloco los parametros que necesito de la ciudad para crearla y actualizarla

            def ciudad_params
                params.require(:ciudad).permit(:pais_id, :nombre, :codigoDane, :codigoAlterno,
                    :usuario_id, :departamento_id)
            end 
        end
    end
end