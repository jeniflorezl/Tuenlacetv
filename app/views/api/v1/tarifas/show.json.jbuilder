json.tarifas do
    json.array! @tarifa do |tarifa|
        json.id tarifa.id
        json.zona tarifa.zona.nombre
        json.concepto tarifa.concepto.nombre
        json.plan tarifa.plan.nombre
        json.valor tarifa.valor
        json.estado tarifa.estado.abreviatura
    end
end