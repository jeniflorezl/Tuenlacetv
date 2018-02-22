module Api
    module V1
        class PlanesController < ApplicationController
            before_action :set_plan_buscar, only: [:show]
            before_action :set_plan, only: [:update, :destroy]

            # GET /planes
            def index
                @planes = Plan.all
                @servicios = Servicio.all
            end

            # GET /planes/id
            # GET /planes/servicio
            # GET /planes/nombre
            def show
            end

            # POST /planes
            def create
                @plan = Plan.new(plan_params)
                if @plan.save 
                    render json: { status: :created }
                else
                    render json: @plan.errors, status: :unprocessable_entity
                end
            end

            # PATCH/PUT /planes/id
            def update
                t = Time.now
                @plan.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                if @plan.update(plan_params)
                    render json: { status: :updated }
                else
                    render json: @plan.errors, status: :unprocessable_entity
                end
            end

            # DELETE /planes/id
            def destroy
                if @plan
                    @plan.destroy()
                    render json: { status: :deleted }
                else
                    render json: { post: "not found" }
                end
            end

            private

            def set_plan
                @plan = Plan.find(params[:id])
            end

            # Me busca la plan por el id, el servicio, o el nombre
            def set_plan_buscar
                @campo = params[:campo]
                @valor = params[:valor]
                if @campo == 'codigo'
                    @plan = Plan.find(params[:valor])
                elsif @campo == 'servicio'
                    @plan = Plan.limit(10).where(servicio_id: @valor)
                else
                    @plan = Plan.limit(10).where("nombre LIKE '%#{@valor}%'")
                end
                @plan = [*@plan]
            end
                
            #Le coloco los parametros que necesito de la plan para crearla y actualizarla

            def plan_params
                params.require(:plan).permit(:servicio_id, :nombre, :usuario_id)
            end 
        end
    end
end