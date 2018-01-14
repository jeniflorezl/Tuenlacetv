json.barrios do
    json.array! @barrios do |barrio|
        json.id barrio.id
        json.zona barrio.zona.nombre
        json.nombre barrio.nombre
        json.usuario barrio.usuario
    end
end

json.zonas do
    json.array! @zonas do |zona|
        json.id zona.id
        json.ciudad zona.ciudad.nombre
        json.nombre zona.nombre
        json.usuario zona.usuario
    end
end