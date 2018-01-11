json.array! @ciudad do |ciudad|
    json.id ciudad.id
    json.id_pais ciudad.pais_id
    json.nombre ciudad.nombre
    json.codigo ciudad.codigo
end