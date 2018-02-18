class Ciudad < ApplicationRecord
  belongs_to :pais
  has_many :zonas
  has_many :bancos
  has_many :empresas

  before_save :uppercase

  validates :pais, :nombre, :usuario, presence: true #obligatorio

  def uppercase
    self.nombre.upcase!
  end
end
