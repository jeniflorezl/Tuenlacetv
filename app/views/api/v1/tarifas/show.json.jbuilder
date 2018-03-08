json.tarifas do
    json.array! @tarifa do |tarifa|
        json.id tarifa.id
        json.zona tarifa.zona.nombre
        json.concepto tarifa.concepto.nombre
        json.plan tarifa.plan.nombre
        json.valor tarifa.valor
        json.estado tarifa.estado.abreviatura
        json.fechas do
            json.array! @historial do |historial|
                if (historial.tarifa_id == tarifa.id)
                    json.fechainicio historial.fechainicio
                    json.fechavence historial.fechavence
                end
            end
        end
    end
end