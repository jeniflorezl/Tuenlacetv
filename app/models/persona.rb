class Persona < ApplicationRecord
  belongs_to :tipo_documento
  belongs_to :barrio
  belongs_to :zona
  has_many :entidades
  validates :tipo_documento_id, :documento, :nombre1, :apellido1, :barrio_id, :zona_id, 
  :tipopersona, :usuario, presence: true #obligatorio
end
