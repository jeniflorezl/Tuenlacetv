FactoryBot.define do
    factory :ciudad do
        association :pais, factory: :pais 
        nombre 'MEDELLIN'
        codigoDane '05001' 
        codigoAlterno ''
        association :usuario, factory: :usuario
    end
end