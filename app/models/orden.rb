class Orden < ApplicationRecord
  belongs_to :entidad
  belongs_to :concepto
  belongs_to :estado
  belongs_to :usuario

  validates :entidad, :concepto, :nrorden, :estado, :usuario, presence: true #obligatorio

  private

  def self.generar_orden(entidad_id, concepto_id, fechatrn, fechaven, valor, observacion, tecnico_id, 
    solicita, usuario_id)

  end
end
