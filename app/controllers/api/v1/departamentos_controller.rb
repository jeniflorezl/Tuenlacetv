module Api
    module V1
        class DepartamentosController < ApplicationController
            before_action :set_departamento_buscar, only: [:show]
            before_action :set_departamento, only: [:update, :destroy]
  
            # GET /departamentoes
            def index
                @departamentos = Departamento.all
                @paises = Pais.all
            end
        
            # GET /departamentoes/id
            def show
            end
        
            # POST /departamentoes
            def create
                @departamento = Departamento.new(departamento_params)
                if @departamento.save 
                    render json: { status: :created }
                else
                    render json: @departamento.errors, status: :unprocessable_entity
                end
            end
        
            # PATCH/PUT /departamentoes/id
            def update
                t = Time.now
                @departamento.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
                if @departamento.update(departamento_params)
                    render json: { status: :updated }
                else
                    render json: @departamento.errors, status: :unprocessable_entity
                end 
            end
        
            # DELETE /departamentoes/id
            def destroy
                if @departamento
                    @departamento.destroy
                    render json: { status: :deleted }
                else
                    render json: { error: "not found" }
                end
            end
        
            
            private

            # Me busca la departamento por el id
            def set_departamento
                @departamento = Departamento.find(params[:id])
            end

            def set_departamento_buscar
                campo = params[:campo]
                valor = params[:valor]
                if @campo == 'id'
                  @departamento = Departamento.find(valor)
                else
                  @departamento = Departamento.where("#{campo} LIKE '%#{valor}%'")
                end
                @departamento = [*@departamento]
            end

            #Le coloco los parametros que necesito de la departamento para crearla y actualizarla

            def departamento_params
                params.require(:departamento).permit(:pais_id, :nombre, :codigo, :usuario_id)
            end 
        end
    end
end