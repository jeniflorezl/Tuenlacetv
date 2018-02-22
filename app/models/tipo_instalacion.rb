class TipoInstalacion < ApplicationRecord
    belongs_to :usuario
    has_many :senales
end
