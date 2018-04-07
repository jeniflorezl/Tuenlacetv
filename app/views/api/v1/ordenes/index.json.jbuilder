json.ordenes do
    json.array! @ordenes do |orden|
        json.id orden["id"]
        json.entidad_id orden["entidad_id"]
        json.nombres orden["nombres"]
        json.direccion orden["direccion"]
        json.telefonos orden["telefonos"]
        json.barrio orden["barrio"]
        json.zona orden["zona"]
        json.fechacontrato orden["fechacontrato"]
        json.fechacontrato orden["precinto"]
        json.observa_senal orden["observa_senal"]
        json.estado_tv orden["estado_tv"]
        json.estado_int orden["estado_int"]
        json.fecha_ult_pago orden["fecha_ult_pago"]
        json.saldo_tv orden["saldo_tv"]
        json.saldo_int orden["saldo_int"]
        json.tipo_orden orden["tipo_orden"]
        json.abreviatura orden["abreviatura"]
        json.nrorden orden["nrorden"]
        json.fechatrn orden["fechatrn"]
        json.fechaven orden["fechaven"]
        json.valor orden["valor"]
        json.estado orden["estado"]
        json.observacion orden["observacion"]
        json.forma_pago orden["forma_pago"]
        json.banco orden["banco"]
        json.cobrador orden["cobrador"]
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