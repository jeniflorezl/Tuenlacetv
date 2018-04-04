json.ordenes do
    json.array! @ordenes do |orden|
        json.id pago["id"]
        json.entidad_id pago["entidad_id"]
        json.nombres pago["nombres"]
        json.direccion pago["direccion"]
        json.telefonos pago["telefonos"]
        json.barrio pago["barrio"]
        json.zona pago["zona"]
        json.fechacontrato pago["fechacontrato"]
        json.fechacontrato pago["precinto"]
        json.observa_senal pago["observa_senal"]
        json.estado_tv pago["estado_tv"]
        json.estado_int pago["estado_int"]
        json.fecha_ult_pago pago["fecha_ult_pago"]
        json.saldo_tv pago["saldo_tv"]
        json.saldo_int pago["saldo_int"]
        json.tipo_orden pago["tipo_orden"]
        json.abreviatura pago["abreviatura"]
        json.nrorden pago["nrorden"]
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

json.empleados do
    json.array! @empleados do |empleado|
        json.id empleado.id
        if empleado.persona.nombre2.blank?
            json.nombres empleado.persona.nombre1 + ' ' + empleado.persona.apellido1 + ' ' + empleado.persona.apellido2
        else
            json.nombres empleado.persona.nombre1 + ' ' + empleado.persona.nombre2 + ' ' + empleado.persona.apellido1 + ' ' + empleado.persona.apellido2
        end
    end
end