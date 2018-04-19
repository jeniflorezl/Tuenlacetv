class NotaFact < ApplicationRecord
    belongs_to :usuario

    validates :fechaElaboracion, :fechaInicio, :fechaFin, :fechaVencimiento,
    :fechaCorte, :fechaPagosVen, :usuario, presence: true #obligatorio
end
