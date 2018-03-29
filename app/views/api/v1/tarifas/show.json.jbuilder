json.tarifas do
    json.array! @tarifa do |tarifa|
        json.id tarifa["id"]
        json.zona tarifa["zona"]
        json.concepto tarifa["concepto"]
        json.plan tarifa["plan_t"]
        json.valor tarifa["valor"]
        json.estado tarifa["estado"]
        json.fechainicio tarifa["fechainicio"]
        json.fechaven tarifa["fechavence"]
    end
end