json.conceptos do
    json.array! @conceptos do |concepto|
        json.id concepto.id
        json.abreviatura concepto.abreviatura
    end
end

json.tarifas do
    json.array! @tarifas do |tarifa|
        json.id tarifa.id
        json.zona_id tarifa.zona_id
        json.concepto_id tarifa.concepto_id
        json.plan_id tarifa.plan_id
        json.valor tarifa.valor
    end
end

json.tecnicos do
    json.array! @tecnicos do |tecnico|
        json.id tecnico.id
        if tecnico.persona.nombre2.blank?
            json.nombres tecnico.persona.nombre1 + ' ' + tecnico.persona.apellido1 + ' ' + tecnico.persona.apellido2
        else
            json.nombres tecnico.persona.nombre1 + ' ' + tecnico.persona.nombre2 + ' ' + tecnico.persona.apellido1 + ' ' + tecnico.persona.apellido2
        end
    end
end

json.grupos do
    json.array! @grupos do |grupo|
        json.id grupo.id
        json.id grupo.descripcion
    end
end

json.articulos do
    json.array! @articulos do |articulo|
        json.id articulo.id
        json.grupo_id articulo.grupo_id
        json.nombre articulo.nombre
        json.costo articulo.costo
        json.porcentajeIva articulo.porcentajeIva
    end
end

json.param_valor @param_valor
json.meses_anteriores @meses_anteriores
json.meses_posteriores @meses_posteriores