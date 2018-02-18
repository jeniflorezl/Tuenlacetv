class Barrio < ApplicationRecord
  belongs_to :zona
  has_many :personas
  has_many :senales

  before_save :uppercase

  validates :zona, :nombre, :usuario, presence: true #obligatorio

  def uppercase
    self.nombre.upcase!
  end
end
