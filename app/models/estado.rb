class Estado < ApplicationRecord
    has_many :senales
    has_many :tarifas
end
