json.ciudades do
    json.array! @ciudades do |ciudad|
        json.id ciudad.id
        json.pais ciudad.pais.nombre
        json.nombre ciudad.nombre
        json.codigoDane ciudad.codigoDane
        json.codigoAlterno ciudad.codigoAlterno
        json.departamento ciudad.departamento.nombre
    end
end

json.paises do
    json.array! @paises do |pais|
        json.id pais.id
        json.nombre pais.nombre
    end
end

json.departamentos do
    json.array! @departamentos do |departamento|
        json.id departamento.id
        json.nombre departamento.nombre
        json.codigo departamento.codigo
    end
end


