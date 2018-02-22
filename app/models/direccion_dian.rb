class DireccionDian < ApplicationRecord
  belongs_to :senal
  belongs_to :nomenclatura
  belongs_to :usuario
end
