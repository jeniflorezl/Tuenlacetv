json.zonas do
    json.array! @zonas do |zona|
        json.id zona.id
        json.ciudad zona.ciudad.nombre
        json.nombre zona.nombre
        json.usuario zona.usuario
    end
end

json.ciudades do
    json.array! @ciudades do |ciudad|
        json.id ciudad.id
        json.pais ciudad.pais.nombre
        json.nombre ciudad.nombre
        json.codigo ciudad.codigo
        json.usuario ciudad.usuario
    end
end