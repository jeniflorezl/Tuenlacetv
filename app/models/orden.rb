class Orden < ApplicationRecord
  self.primary_keys = :concepto_id, :nrorden
  belongs_to :senal
  belongs_to :concepto
  belongs_to :estado
  belongs_to :usuario
  has_many :detalle_orden, :class_name => 'DetalleOrden', :foreign_key => [:concepto_id, :nrorden]

  validates :senal, :concepto, :estado, presence: true #obligatorio
end
