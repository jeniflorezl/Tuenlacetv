class Empresa < ApplicationRecord
  belongs_to :entidad
  belongs_to :ciudad
end
