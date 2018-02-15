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

json.paises do
    json.array! @paises do |pais|
        json.id pais.id
        json.nombre pais.nombre
        json.usuario pais.usuario
    end
end


