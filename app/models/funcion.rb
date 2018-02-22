class Funcion < ApplicationRecord
    belongs_to :usuario
    has_many :entidades
end
