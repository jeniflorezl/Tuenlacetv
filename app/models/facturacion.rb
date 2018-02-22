class Facturacion < ApplicationRecord
  belongs_to :entidad
  belongs_to :documento
  belongs_to :estado
end
