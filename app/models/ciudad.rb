class Ciudad < ApplicationRecord
  belongs_to :pais
  has_many :zonas
end
