json.bancos do
    json.array! @banco do |banco|
        json.id banco.id
        json.nit banco.nit
        json.nombre banco.nombre
        json.direccion banco.direccion
        json.ciudad banco.ciudad.nombre
        json.telefono1 banco.telefono1
        json.telefono2 banco.telefono2
        json.contacto banco.contacto
        json.cuentaBancaria banco.cuentaBancaria
        json.cuentaContable banco.cuentaContable
    end
end