module Api
    module V1
        class BarriosController < ApplicationController
            before_action :set_barrio_buscar, only: [:show]
            before_action :set_barrio, only: [:update, :destroy]

            # GET /barrios
            def index
                @barrios = Barrio.all
                @zonas = Zona.all
            end

            # GET /barrios/id
            # GET /barrios/zona
            # GET /barrios/nombre
            def show
            end

            # POST /barrios
            def create
                @barrio = Barrio.new(barrio_params)
                if @barrio.save 
                    render json: { status: :created }
                else
                    render json: @barrio.errors, status: :unprocessable_entity
                end
            end

            # PATCH/PUT /barrios/id
            def update
                t = Time.now
                @barrio.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                if @barrio.update(barrio_params)
                    render json: { status: :updated }
                else
                    render json: @barrio.errors, status: :unprocessable_entity
                end
            end

            # DELETE /barrios/id
            def destroy
                if @barrio
                    @barrio.destroy()
                    render json: { status: :deleted }
                else
                    render json: { post: "not found" }
                end
            end

            private

            def set_barrio
                @barrio = Barrio.find(params[:id])
            end
            
            # Me busca el barrio por el id, la zona o el nombre
            def set_barrio_buscar
                campo = params[:campo]
                valor = params[:valor]
                if campo == 'id'
                    @barrio = Barrio.find(valor)
                elsif campo == 'zona'
                    @barrio = Barrio.where(zona_id: valor)
                else
                    @barrio = Barrio.where("nombre LIKE '%#{valor}%'")
                end
                @barrio = [*@barrio]
            end


            #Le coloco los parametros que necesito del barrio para crearlo y actualizarlo

            def barrio_params
                params.require(:barrio).permit(:zona_id, :nombre, :usuario_id)
            end 
        end
    end
end
