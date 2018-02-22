class Articulo < ApplicationRecord
  belongs_to :grupo
  belongs_to :unidad
end
