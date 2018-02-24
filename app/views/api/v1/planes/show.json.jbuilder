json.array! @plan do |plan|
    json.id plan.id
    json.servicio plan.servicio.nombre
    json.nombre plan.nombre
end