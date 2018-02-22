class DireccionZona < ApplicationRecord
  belongs_to :zona
  belongs_to :usuario

  before_save :uppercase

  validates :zona, :direccion, :usuario, presence: true #obligatorio

  def uppercase
    self.direccion.upcase!
  end
end
