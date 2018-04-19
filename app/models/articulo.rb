class Articulo < ApplicationRecord
  belongs_to :grupo
  belongs_to :unidad
  belongs_to :usuario
end
