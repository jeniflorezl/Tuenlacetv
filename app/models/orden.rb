class Orden < ApplicationRecord
  belongs_to :senal
  belongs_to :concepto
  belongs_to :estado
  belongs_to :entidad
end
