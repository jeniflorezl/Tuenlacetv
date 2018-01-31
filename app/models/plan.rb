class Plan < ApplicationRecord
  belongs_to :servicio
  has_many :tarifas
  validates :servicio_id, :nombre, :usuario, presence: true #obligatorio
end