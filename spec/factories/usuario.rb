FactoryBot.define do
    factory :usuario do
        login 'jeniferfl'
        nombre 'Jeniffer Florez'
        password '123'
        password_confirmation '123'
        token ''
        nivel '2'
        association :estado, factory: :estado
        tipoImpresora 'L'
        association :usuario, factory: :usuario
    end
end