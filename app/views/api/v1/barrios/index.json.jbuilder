json.array! @barrios do |barrio|
    json.id barrio.id
    json.id_zona barrio.zona_id
    json.nombre barrio.nombre
end