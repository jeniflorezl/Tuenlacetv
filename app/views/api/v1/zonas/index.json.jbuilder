json.array! @zonas do |zona|
    json.id zona.id
    json.ciudad zona.ciudad.nombre
    json.nombre zona.nombre
    json.usuario zona.usuario
end