class Facturacion < ApplicationRecord
  self.primary_keys = :documento_id, :prefijo, :nrofact
  belongs_to :entidad
  belongs_to :documento
  belongs_to :estado
  belongs_to :usuario
  has_many :detalle_factura, :class_name => 'DetalleFactura', :foreign_key => [:documento_id, :prefijo, :nrofact]

  validates :entidad, :documento, :fechatrn, :fechaven, :valor, :iva, :dias, :prefijo, :nrofact,
  :estado, :reporta, :usuario, presence: true #obligatorio
end
