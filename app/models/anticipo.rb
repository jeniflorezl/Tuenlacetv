class Anticipo < ApplicationRecord
  belongs_to :entidad
  belongs_to :servicio
  belongs_to :usuario

  validates :entidad, :servicio, :fechatrn, :fechaven, :valor, :usuario, presence: true #obligatorio
end
