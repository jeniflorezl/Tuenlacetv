json.pagos do
    json.array! @pagos do |pago|
        json.entidad_id pago["entidad_id"]
        json.nombre do
            json.array! @entidades do |entidad|
                if pago["entidad_id"] == entidad["id"]
                    if entidad["nombre2"].blank?
                        json.nombres entidad["nombre1"] + ' ' + entidad["apellido1"] + ' ' + entidad["apellido2"]
                    else
                        json.nombres entidad["nombre1"] + ' ' + entidad["nombre2"] + ' ' + entidad["apellido1"] + ' ' + entidad["apellido2"]
                    end
                end
                if pago["cobrador_id"] == entidad["id"]
                    if entidad["nombre2"].blank?
                        json.nombres entidad["nombre1"] + ' ' + entidad["apellido1"] + ' ' + entidad["apellido2"]
                    else
                        json.nombres entidad["nombre1"] + ' ' + entidad["nombre2"] + ' ' + entidad["apellido1"] + ' ' + entidad["apellido2"]
                    end
                end
            end
        end
        json.documentos do
            json.array! @documentos do |documento|
                if pago["documento_id"] == documento.id
                    json.documento documento.nombre
                end
            end
        end
        json.nropago pago["nropago"]
        json.fechatrn pago["fechatrn"]
        json.fechaven pago["fechaven"]
        json.valor pago["valor"]
        #json.estado pago.estado.nombre

        json.observacion pago["observacion"]
        #json.forma_pago pago.forma_pago.nombre
        #json.banco pago.banco.nombre
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