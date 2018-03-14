class Ciudad < ApplicationRecord
  belongs_to :pais
  belongs_to :usuario
  belongs_to :departamento
  has_many :zonas
  has_many :bancos
  has_many :empresas

  before_save :uppercase

  validates :pais, :nombre, :usuario, :departamento, presence: true #obligatorio

  def uppercase
    self.nombre.upcase!
  end
end
