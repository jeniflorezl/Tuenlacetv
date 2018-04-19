class Concepto < ApplicationRecord
  belongs_to :servicio
  belongs_to :usuario
  has_many :tarifas

  before_validation :codigo_concepto
  
  before_save :uppercase

  validates :servicio, :codigo, :nombre, :porcentajeIva, :abreviatura, :operacion,
  :usuario, presence: true #obligatorio

  validates :codigo, uniqueness: true

  def uppercase
    self.nombre.upcase!
    self.abreviatura.upcase!
  end

  def codigo_concepto
    unless self.codigo == nil
      if self.codigo.length == 1
        self.codigo = '00' + self.codigo
      elsif self.codigo.length == 2
        self.codigo = '0' + self.codigo
      end
    end
  end
end
