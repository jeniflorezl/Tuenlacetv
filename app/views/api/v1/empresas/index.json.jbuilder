json.empresas do
    json.array! @empresas do |empresa|
        json.id empresa.id
        json.tipo empresa.tipo
        json.nit empresa.nit
        json.razonsocial empresa.razonsocial
        json.direccion empresa.direccion
        json.telefono1 empresa.telefono1
        json.telefono2 empresa.telefono2
        json.ciudad empresa.ciudad.nombre
        json.representante do
            json.array! @representantes do |repre|
                json.id repre.id
                json.nombres repre.persona.nombre1 + '' + repre.persona.nombre2 + ' ' + repre.persona.apellido1 + ' ' + repre.persona.apellido2
            end
        end
        json.logo empresa.logo
        json.correo empresa.correo
        json.regimen empresa.regimen
        json.contribuyente empresa.contribuyente
        json.centrocosto empresa.centrocosto
    end
end

json.ciudades do
    json.array! @ciudades do |ciudad|
        json.id ciudad.id
        json.pais ciudad.pais.nombre
        json.nombre ciudad.nombre
        json.codigoDane ciudad.codigoDane
        json.codigoAlterno ciudad.codigoAlterno
    end
end

json.representantes do
    json.array! @representantes do |repre|
        json.id repre.id
        json.nombres repre.persona.nombre1 + '' + repre.persona.nombre2 + ' ' + repre.persona.apellido1 + ' ' + repre.persona.apellido2
    end
end