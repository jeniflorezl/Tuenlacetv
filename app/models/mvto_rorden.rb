class MvtoRorden < ApplicationRecord
  belongs_to :registro_orden
  belongs_to :usuario

  validates :valor, :usuario, presence: true #obligatorio
end
