json.array! @barrios do |barrio|
    json.id barrio.id
    json.zona barrio.zona.nombre
    json.nombre barrio.nombre
    json.usuario barrio.usuario
end