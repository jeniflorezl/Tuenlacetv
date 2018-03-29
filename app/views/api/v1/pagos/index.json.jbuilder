json.pagos do
    json.array! @pagos do |pago|
        json.id pago["id"]
        json.entidad_id pago["entidad_id"]
        json.entidad_id pago["tipo_documento"]
        json.entidad_id pago["documento_persona"]
        json.entidad_id pago["nombres"]
        json.entidad_id pago["telefonos"]
        json.entidad_id pago["direccion"]
        json.entidad_id pago["barrio"]
        json.entidad_id pago["zona"]
        json.entidad_id pago["estado_tv"]
        json.entidad_id pago["estado_int"]
        json.entidad_id pago["fechacontrato"]
        json.entidad_id pago["fecha_ult_pago"]
        json.entidad_id pago["documento"]
        json.entidad_id pago["nropago"]
        json.entidad_id pago["fechatrn"]
        json.entidad_id pago["fechaven"]
        json.entidad_id pago["valor"]
        json.entidad_id pago["estado"]
        json.entidad_id pago["observacion"]
        json.entidad_id pago["forma_pago"]
        json.entidad_id pago["banco"]
        json.entidad_id pago["cobrador"]
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