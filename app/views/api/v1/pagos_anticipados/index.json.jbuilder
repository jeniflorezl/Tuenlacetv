json.pagos_anticipados do
    json.array! @pagos_anticipados do |pago|
        json.id pago["id"]
        json.entidad_id pago["entidad_id"]
        json.nombres pago["nombres"]
        json.direccion pago["direccion"]
        json.telefonos pago["telefonos"]
        json.barrio pago["barrio"]
        json.zona pago["zona"]
        json.fechacontrato pago["fechacontrato"]
        json.observa_senal pago["observa_senal"]
        json.estado_tv pago["estado_tv"]
        json.estado_int pago["estado_int"]
        json.fecha_ult_pago pago["fecha_ult_pago"]
        json.saldo_tv pago["saldo_tv"]
        json.saldo_int pago["saldo_int"]
        json.servicio pago["servicio"]
        json.documento pago["documento"]
        json.nropago pago["nropago"]
        json.fechatrn pago["fechatrn"]
        json.fechapxa pago["fechapxa"]
        json.cuotas pago["cuotas"]
        json.valor pago["valor"]
        json.observacion pago["observacion"]
        json.forma_pago pago["forma_pago"]
        json.banco pago["banco"]
        json.cobrador pago["cobrador"]
    end
end

json.param_cobradores @param_cobradores