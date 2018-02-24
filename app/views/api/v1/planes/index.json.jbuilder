json.planes do
    json.array! @planes do |plan|
        json.id plan.id
        json.servicio plan.servicio.nombre
        json.nombre plan.nombre
    end
end

json.servicios do
    json.array! @servicios do |servicio|
        json.id servicio.id
        json.nombre servicio.nombre
    end
end