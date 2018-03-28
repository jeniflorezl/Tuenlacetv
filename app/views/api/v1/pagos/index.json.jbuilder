json.pagos do
    json.array! @pagos do |pago|
        json.entidad_id pago["entidad_id"]
        json.array! @entidades do |entidad|
            if pago["entidad_id"] == entidad.id
                json.array! @personas do |persona|
                    if entidad.persona_id == persona.id
                        if persona.nombre2.blank?
                            json.nombres persona.nombre1 + ' ' + persona.apellido1 + ' ' + persona.apellido2
                            break
                        else
                            json.nombres persona.nombre1 + ' ' + persona.nombre2 + ' ' + persona.apellido1 + ' ' + persona.apellido2
                            break
                        end
                    end
                end
            end
        end
        json.documento pago.documento.nombre
        json.nropago pago.nropago
        json.fechatrn pago.fechatrn
        json.fechaven pago.fechaven
        json.valor pago.valor
        json.estado pago.estado.nombre
        json.observacion pago.observacion
        json.forma_pago pago.forma_pago.nombre
        json.banco pago.banco.nombre
        if pago.cobrador.entidad.persona.nombre2.blank?
            json.cobrador pago.cobrador.entidad.persona.nombre1 + ' ' + pago.cobrador.entidad.persona.apellido1 + ' ' + pago.cobrador.entidad.persona.apellido2
        else
            json.cobrador pago.cobrador.entidad.persona.nombre1 + ' ' + pago.cobrador.entidad.persona.nombre2 + ' ' + pago.cobrador.entidad.persona.apellido1 + ' ' + pago.cobrador.entidad.persona.apellido2
        end
    end
end

json.documentos do
    json.array! @documentos do |documento|
        json.id documento.id
        json.nombre documento.nombre
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