class InfoInternet < ApplicationRecord
  belongs_to :usuario
  belongs_to :senal

  validates :senal, :direccionip, :velocidad, :mac1, :usuario, presence: true #obligatorio

end
