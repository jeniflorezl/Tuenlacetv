class Facturacion < ApplicationRecord
  belongs_to :entidad
  belongs_to :documento
  belongs_to :estado
  belongs_to :usuario

  validates :entidad, :documento, :fechatrn, :fechaven, :valor, :iva, :dias, :prefijo, :nrofact,
  :estado, :reporta, :usuario, presence: true #obligatorio
end
