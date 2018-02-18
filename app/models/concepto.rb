class Concepto < ApplicationRecord
  belongs_to :servicio
  has_many :tarifas

  before_save :uppercase

  validates :servicio, :codigo, :nombre, :porcentajeIva, :abreviatura, :operacion,
  :usuario, presence: true #obligatorio

  def uppercase
    self.nombre.upcase!
    self.abreviatura.upcase!
  end
end
