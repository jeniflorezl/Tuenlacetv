class Plan < ApplicationRecord
  belongs_to :servicio
  has_many :tarifas

  before_save :uppercase

  validates :servicio, :nombre, :usuario, presence: true #obligatorio

  def uppercase
    self.nombre.upcase!
  end
end
