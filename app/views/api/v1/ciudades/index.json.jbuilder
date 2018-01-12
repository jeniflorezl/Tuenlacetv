json.array! @ciudades do |ciudad|
    json.id ciudad.id
    json.pais ciudad.pais.nombre
    json.nombre ciudad.nombre
    json.codigo ciudad.codigo
    json.usuario ciudad.usuario
end