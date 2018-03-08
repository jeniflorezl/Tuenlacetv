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
                    @estados = Estado.all
                    @historial = HistorialTarifa.all
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
                        HistorialTarifa.create(tarifa_id: @tarifa.id, zona_id: @tarifa.zona_id,
                            concepto_id: @tarifa.concepto_id, plan_id: @tarifa.plan_id, valor: @tarifa.valor,
                            fechainicio: params[:fechainicio], fechavence: params[:fechaven], 
                            ccosto: Empresa.first.centrocosto, usuario_id: @tarifa.usuario_id)
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
                        htarifa = HistorialTarifa.find_by(tarifa_id: @tarifa.id)
                        if (htarifa.fechainicio == params[:fechainicio]) and (htarifa.fechavence == params[:fechaven])
                            htarifa.update(tarifa_id: @tarifa.id, zona_id: @tarifa.zona_id,
                                concepto_id: @tarifa.concepto_id, plan_id: @tarifa.plan_id, valor: @tarifa.valor,
                                fechainicio: params[:fechainicio], fechavence: params[:fechaven], 
                                ccosto: Empresa.first.centrocosto, usuario_id: @tarifa.usuario_id)
                        else
                            HistorialTarifa.create(tarifa_id: @tarifa.id, zona_id: @tarifa.zona_id,
                                concepto_id: @tarifa.concepto_id, plan_id: @tarifa.plan_id, valor: @tarifa.valor,
                                fechainicio: params[:fechainicio], fechavence: params[:fechaven], 
                                ccosto: Empresa.first.centrocosto, usuario_id: @tarifa.usuario_id)
                        end
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
                    if @campo == 'id'
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
                    @historial = HistorialTarifa.all
                end

                def set_tarifa
                    @tarifa = Tarifa.find(params[:id])
                    @historial = HistorialTarifa.all
                end

                #Le coloco los parametros que necesito de la tarifa para crearla y actualizarla
                def tarifa_params
                    params.require(:tarifa).permit(:zona_id, :concepto_id, :plan_id, :valor, :estado_id, 
                    :usuario_id)
                end 
        end
    end
end