class Persona < ApplicationRecord
  belongs_to :tipo_documento
  belongs_to :barrio
  belongs_to :zona
  has_many :entidades
  validates :tipo_documento, :documento, :nombre1, :apellido1, :barrio, :zona, 
  :tipopersona, :usuario, presence: true #obligatorio
end
