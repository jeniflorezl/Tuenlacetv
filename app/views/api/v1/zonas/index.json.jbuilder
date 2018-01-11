json.array! @zonas do |zona|
    json.id zona.id
    json.id_ciudad zona.ciudad_id
    json.nombre zona.nombre
end