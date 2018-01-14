class Servicio < ApplicationRecord
    has_many :conceptos
    has_many :planes
end
