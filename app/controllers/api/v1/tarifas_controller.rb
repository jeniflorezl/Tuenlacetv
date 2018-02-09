module Api
    module V1
        class TarifasController < ApplicationController
            before_action :set_tarifa_buscar, only: [:show]
            before_action :set_tarifa, only: [:update, :destroy]
            
                # GET /tarifas
                def index
                    @tarifas = Tarifa.all
                    @zonas = Zona.all
                    @conceptos = Concepto.all
                    @planes = Plan.all
                end
            
                # GET /tarifas/id
                # GET /tarifas/zona_id
                # GET /tarifas/concepto_id
                # GET /tarifas/plan_id
                # GET /tarifas/valor
                # GET /tarifas/estado
                def show
                end
            
                # POST /tarifas
                def create
                    @tarifa = Tarifa.new(tarifa_params)
                    if @tarifa.save 
                        render json: { status: :created }
                    else
                        render json: @tarifa.errors, status: :unprocessable_entity
                    end
                end
            
                # PATCH/PUT /tarifas/id
                def update
                    t = Time.now
                    @tarifa.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                    if @tarifa.update(tarifa_params)
                        render json: { status: :updated }
                    else
                        render json: @tarifa.errors, status: :unprocessable_entity
                    end
                end
            
                # DELETE /tarifas/id
                def destroy
                    if @tarifa
                        @tarifa.destroy()
                        render json: { status: :deleted }
                    else
                        render json: { post: "not found" }
                    end
                end
            
                private

                # Me busca la tarifa por el id, por la zona, el concepto, el plan, el valor, o el
                # estado
                def set_tarifa_buscar
                    @campo = params[:campo]
                    @valor = params[:valor]
                    if @campo == 'codigo'
                        @tarifa = Tarifa.find(params[:valor])
                    elsif @campo == 'zona'
                        @tarifa = Tarifa.limit(10).where(zona_id: @valor)
                    elsif @campo == 'concepto'
                        @tarifa = Tarifa.limit(10).where(concepto_id: @valor)
                    elsif @campo == 'plan'
                        @tarifa = Tarifa.limit(10).where(plan_id: @valor)
                    else
                        @tarifa = Tarifa.limit(10).where(valor: @valor)
                    end
                    @tarifa = [*@tarifa]
                end

                def set_tarifa
                @tarifa = Tarifa.find(params[:id])
                end

                #Le coloco los parametros que necesito de la tarifa para crearla y actualizarla
                def tarifa_params
                    params.require(:tarifa).permit(:zona_id, :concepto_id, :plan_id, :valor, :estado, 
                    :usuario)
                end 
        end
    end
end