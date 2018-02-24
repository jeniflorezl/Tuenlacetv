json.tarifas do
    json.array! @tarifas do |tarifa|
        json.id tarifa.id
        json.zona tarifa.zona.nombre
        json.concepto tarifa.concepto.nombre
        json.plan tarifa.plan.nombre
        json.valor tarifa.valor
        json.estado tarifa.estado.nombre
    end
end

json.zonas do
    json.array! @zonas do |zona|
        json.id zona.id
        json.ciudad zona.ciudad.nombre
        json.nombre zona.nombre
    end
end

json.conceptos do
    json.array! @conceptos do |concepto|
        json.id concepto.id
        json.servicio concepto.servicio.nombre
        json.codigo concepto.codigo
        json.nombre concepto.nombre
        json.porcentajeIva concepto.porcentajeIva
        json.abreviatura concepto.abreviatura
        json.operacion concepto.operacion
    end
end

json.planes do
    json.array! @planes do |plan|
        json.id plan.id
        json.servicio plan.servicio.nombre
        json.nombre plan.nombre
    end
end

json.estados do
    json.array! @estados do |estado|
        json.id estado.id
        json.nombre estado.nombre
    end
end





