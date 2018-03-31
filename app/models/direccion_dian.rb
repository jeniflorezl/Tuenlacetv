class DireccionDian < ApplicationRecord
  belongs_to :entidad
  belongs_to :nomenclatura
  belongs_to :usuario
end
