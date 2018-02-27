FactoryBot.define do
    factory :banco do
        nit '900938640'
        nombre 'PTO PAGO SUR'
        direccion ''
        association :ciudad, factory: :ciudad
        telefono1 '0'
        telefono2 '0' 
        contacto '' 
        cuentaBancaria '110455' 
        cuentaContable ''
        usuario_id 1
        association :usuario, factory: :usuario
    end
end