module Api
    module V1
        class TarifasController < ApplicationController
            before_action :set_tarifa_buscar, only: [:show]
            before_action :set_tarifa, only: [:update, :destroy]
            
                # GET /tarifas
                def index
                    query = <<-SQL 
                    SELECT * FROM VwTarifas;
                    SQL
                    @tarifas = Tarifa.connection.select_all(query)
                    @zonas = Zona.all
                    @conceptos = Concepto.all
                    @planes = Plan.all
                    @estados = Estado.where("abreviatura = 'A' or abreviatura = 'IN'")
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
                    ban = 0
                    t = Time.now
                    @tarifa.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                    if @tarifa.update(tarifa_params)
                        htarifa = HistorialTarifa.find_by(tarifa_id: @tarifa.id)
                        if htarifa
                            if (htarifa.fechainicio == params[:fechainicio]) and (htarifa.fechavence == params[:fechaven])
                                htarifa.update(tarifa_id: @tarifa.id, zona_id: @tarifa.zona_id,
                                    concepto_id: @tarifa.concepto_id, plan_id: @tarifa.plan_id, valor: @tarifa.valor,
                                    fechainicio: params[:fechainicio], fechavence: params[:fechaven], 
                                    ccosto: Empresa.first.centrocosto, usuario_id: @tarifa.usuario_id)
                            else
                                ban = 1
                            end
                        else
                            ban = 1
                        end
                        if ban == 1
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
                        @historial.each do |h|
                            h.destroy()
                        end
                        render json: { status: :deleted }
                    else
                        render json: { post: "not found" }
                    end
                end
            
                private

                # Me busca la tarifa por el id, por la zona, el concepto, el plan, el valor, o el
                # estado
                def set_tarifa_buscar
                    campo = params[:campo]
                    valor = params[:valor]
                    query = <<-SQL 
                    SELECT TOP(10) * FROM VwTarifas WHERE #{campo} LIKE '%#{valor}%';
                    SQL
                    @tarifa = ActiveRecord::Base.connection.select_all(query)
                    @tarifa = [*@tarifa]
                end

                def set_tarifa
                    @tarifa = Tarifa.find(params[:id])
                    @historial = HistorialTarifa.where(tarifa_id: @tarifa.id)
                end

                #Le coloco los parametros que necesito de la tarifa para crearla y actualizarla
                def tarifa_params
                    params.require(:tarifa).permit(:zona_id, :concepto_id, :plan_id, :valor, 
                        :estado_id, :usuario_id)
                end 
        end
    end
end