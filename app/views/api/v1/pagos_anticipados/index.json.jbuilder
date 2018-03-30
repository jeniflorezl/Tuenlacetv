json.pagos_anticipados do
    json.array! @pagos_anticipados do |pago|
        json.id pago["id"]
        json.entidad_id pago["entidad_id"]
        json.tipo_documento pago["tipo_documento"]
        json.documento_persona pago["documento_persona"]
        json.nombres pago["nombres"]
        json.telefonos pago["telefonos"]
        json.direccion pago["direccion"]
        json.barrio pago["barrio"]
        json.zona pago["zona"]
        json.estado_tv pago["estado_tv"]
        json.estado_int pago["estado_int"]
        json.fechacontrato pago["fechacontrato"]
        json.fecha_ult_pago pago["fecha_ult_pago"]
        json.documento pago["documento"]
        json.nropago pago["nropago"]
        json.fechatrn pago["fechatrn"]
        json.fechaven pago["fechaven"]
        json.valor pago["valor"]
        json.estado pago["estado"]
        json.observacion pago["observacion"]
        json.forma_pago pago["forma_pago"]
        json.banco pago["banco"]
        json.cobrador pago["cobrador"]
    end
end

json.conceptos do
    json.array! @conceptos do |concepto|
        json.id concepto.id
        json.nombre concepto.nombre
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