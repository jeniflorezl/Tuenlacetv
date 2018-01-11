class Ciudad < ApplicationRecord
  belongs_to :pais
  has_many :zonas
  validates :pais_id, :nombre, :codigo, :usuario, presence: true #obligatorio
end
