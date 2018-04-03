module Api
  module V1
      class PaisesController < ApplicationController
        before_action :set_pais_buscar, only: [:show]
        before_action :set_pais, only: [:update, :destroy]
          
        # GET /paises
        def index
          @paises = Pais.all
        end
          
        # GET /paises/id
        def show
        end
          
        # POST /paises
        def create
          @pais = Pais.new(pais_params)
          if @pais.save 
            render json: { status: :created }
          else
            render json: @pais.errors, status: :unprocessable_entity
          end
        end
          
        # PATCH/PUT /paises/id
        def update
          t = Time.now
          @pais.fechacam = t.strftime("%d/%m/%Y %H:%M:%S")
          if @pais.update(pais_params)
            render json: { status: :updated }
          else
            render json: @pais.errors, status: :unprocessable_entity
          end
        end
          
        # DELETE /paises/id
        def destroy
          if @pais
            @pais.destroy
            render json: { status: :deleted }
          else
            render json: { post: "not found" }
          end
        end
            
        private

        # Me busca el pais por el id
        def set_pais
          @pais = Pais.find(params[:id])
        end

        def set_pais_buscar
          campo = params[:campo]
          valor = params[:valor]
          if campo == 'id'
            @pais = Pais.find(valor)
          else
            @pais = Pais.where("nombre LIKE '%#{valor}%'")
          end
          @pais = [*@pais]
        end

        #Le coloco los parametros que necesito del pais para crearlo y actualizarlo

        def pais_params
          params.require(:pais).permit(:nombre, :usuario_id)
        end 
      end
    end
end