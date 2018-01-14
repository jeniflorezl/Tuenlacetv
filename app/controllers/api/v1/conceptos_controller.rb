module Api
    module V1
        class ConceptosController < ApplicationController
            before_action :set_concepto_buscar, only: [:show]
            before_action :set_concepto, only: [:update, :destroy]

            # GET /conceptos
            def index
                @conceptos = Concepto.all
                @servicios = Servicio.all
            end

            # GET /conceptos/id
            # GET /conceptos/servicio
            # GET /conceptos/nombre
            # GET /conceptos/tipo documento
            def show
            end

            # POST /conceptos
            def create
                @concepto = Concepto.new(concepto_params)
                if @concepto.save 
                    render json: { status: :created }
                else
                    render json: @concepto.errors, status: :unprocessable_entity
                end
            end

            # PATCH/PUT /conceptos/id
            def update
                t = Time.now
                @concepto.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                if @concepto.update(concepto_params)
                    render json: { status: :updated }
                else
                    render json: @concepto.errors, status: :unprocessable_entity
                end
            end

            # DELETE /conceptos/id
            def destroy
                if @concepto
                    @concepto.destroy()
                    render json: { status: :deleted }
                else
                    render json: { post: "not found" }
                end
            end

            private

            def set_concepto
                @concepto = Concepto.find(params[:id])
            end
            
            # Me busca el concepto por el id, servicio o el nombre
            def set_concepto_buscar
                @campo = params[:campo]
                @valor = params[:valor]
                if @campo == 'codigo'
                    @concepto = Concepto.find(params[:valor])
                elsif @campo == 'servicio'
                    @concepto = Concepto.limit(10).where(servicio_id: @valor)
                else
                    @concepto = Concepto.limit(10).where("nombre LIKE '%#{@valor}%'")
                end
                @concepto = [*@concepto]
            end


            #Le coloco los parametros que necesito del concepto para crearlo y actualizarlo

            def concepto_params
                params.require(:concepto).permit(:servicio_id, :codigo, :nombre, :porcentajeIva, 
                :abreviatura, :operacion,:usuario)
            end 
        end
    end
end