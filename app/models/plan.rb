class Plan < ApplicationRecord
  belongs_to :servicio
  has_many :tarifas
  validates :servicio, :nombre, :usuario, presence: true #obligatorio
end
