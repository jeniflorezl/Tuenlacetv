class Banco < ApplicationRecord
  belongs_to :ciudad
  belongs_to :usuario

  before_save :uppercase

  validates :nombre, :ciudad, :usuario, presence: true #obligatorio

  def uppercase
    self.nombre.upcase!
  end
end
