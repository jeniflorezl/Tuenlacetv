FactoryBot.define do
    factory :pais do
        nombre 'COLOMBIA'
        association :usuario, factory: :usuario
    end
end