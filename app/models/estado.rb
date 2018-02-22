class Estado < ApplicationRecord
    has_many :senales
    has_many :tarifas
    has_many :usuarios
end
