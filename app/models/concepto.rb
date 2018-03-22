class Concepto < ApplicationRecord
  belongs_to :servicio
  belongs_to :usuario
  has_many :tarifas

  before_save :uppercase

  validates :servicio, :codigo, :nombre, :porcentajeIva, :abreviatura, :operacion,
  :usuario, presence: true #obligatorio

  validates :codigo, uniqueness: true

  def uppercase
    self.nombre.upcase!
    self.abreviatura.upcase!
  end
end
