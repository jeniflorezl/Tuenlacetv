json.conceptos do
    json.array! @concepto do |concepto|
        json.id concepto.id
        json.servicio concepto.servicio.nombre
        json.codigo concepto.codigo
        json.nombre concepto.nombre
        json.porcentajeIva concepto.porcentajeIva
        json.abreviatura concepto.abreviatura
        json.operacion concepto.operacion
    end
end