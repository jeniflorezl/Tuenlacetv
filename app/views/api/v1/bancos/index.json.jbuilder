json.bancos do
    json.array! @bancos do |banco|
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
        json.usuario banco.usuario
    end
end

json.ciudades do
    json.array! @ciudades do |ciudad|
        json.id ciudad.id
        json.pais ciudad.pais.nombre
        json.nombre ciudad.nombre
        json.codigoDane ciudad.codigoDane
        json.codigoAlterno ciudad.codigoAlterno
        json.usuario ciudad.usuario
    end
end