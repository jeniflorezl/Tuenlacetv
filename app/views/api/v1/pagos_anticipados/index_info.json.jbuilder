json.servicios do
    json.array! @servicios do |servicio|
        json.id servicio.id
        json.abreviatura servicio.nombre
    end
end

json.documentos do
    json.array! @documentos do |documento|
        json.id documento.id
        json.abreviatura documento.abreviatura
    end
end

json.param_cobradores @param_cobradores

json.cobradores do
    json.array! @cobradores do |cobrador|
        json.id cobrador.id
        if cobrador.persona.nombre2.blank?
            json.nombres cobrador.persona.nombre1 + ' ' + cobrador.persona.apellido1 + ' ' + cobrador.persona.apellido2
        else
            json.nombres cobrador.persona.nombre1 + ' ' + cobrador.persona.nombre2 + ' ' + cobrador.persona.apellido1 + ' ' + cobrador.persona.apellido2
        end
    end
end

json.formas_pago do
    json.array! @formas_pago do |forma_pago|
        json.id forma_pago.id
        json.nombre forma_pago.nombre
    end
end

json.bancos do
    json.array! @bancos do |banco|
        json.id banco.id
        json.nombre banco.nombre
    end
end