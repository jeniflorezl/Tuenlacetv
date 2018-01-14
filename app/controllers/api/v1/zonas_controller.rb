module Api
    module V1
        class ZonasController < ApplicationController
            before_action :set_zona_buscar, only: [:show]
            before_action :set_zona, only: [:update, :destroy]

            # GET /zonas
            def index
                @zonas = Zona.all
                @ciudades = Ciudad.all
            end

            # GET /zonas/id
            # GET /zonas/nombre
            def show
            end

            # POST /zonas
            def create
                @zona = Zona.new(zona_params)
                if @zona.save 
                    render json: { status: :created }
                else
                    render json: @zona.errors, status: :unprocessable_entity
                end
            end

            # PATCH/PUT /zonas/id
            def update
                t = Time.now
                @zona.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                if @zona.update(zona_params)
                    render json: { status: :updated }
                else
                    render json: @zona.errors, status: :unprocessable_entity
                end
            end

            # DELETE /zonas/id
            def destroy
                if @zona
                    @zona.destroy()
                    render json: { status: :deleted }
                else
                    render json: { post: "not found" }
                end
            end

            private

            def set_zona
                @zona = Zona.find(params[:id])
            end

            # Me busca la zona por el id o el nombre
            def set_zona_buscar
                @campo = params[:campo]
                @valor = params[:valor]
                if @campo == 'codigo'
                    @zona = Zona.find(params[:valor])
                else
                    @zona = Zona.limit(10).where("nombre LIKE '%#{@valor}%'")
                end
                @zona = [*@zona]
            end
                
            #Le coloco los parametros que necesito de la zona para crearla y actualizarla

            def zona_params
                params.require(:zona).permit(:ciudad_id, :nombre, :dirquejas, :usuario)
            end 
        end
    end
end