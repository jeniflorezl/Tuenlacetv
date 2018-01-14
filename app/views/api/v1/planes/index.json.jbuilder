json.array! @planes do |plan|
    json.id plan.id
    json.servicio plan.servicio.nombre
    json.nombre plan.nombre
    json.usuario plan.usuario
end