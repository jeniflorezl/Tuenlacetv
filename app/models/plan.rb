class Plan < ApplicationRecord
  belongs_to :servicio
  validates :servicio_id, :nombre, :usuario, presence: true #obligatorio
end
