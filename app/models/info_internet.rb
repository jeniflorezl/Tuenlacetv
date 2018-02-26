class InfoInternet < ApplicationRecord
  belongs_to :usuario
  belongs_to :senal

  validates :usuario, presence: true #obligatorio

end
