json.senales do
    json.array! @senal do |senal|
        json.codigo senal["id"]
        json.documento senal["documento"]
        json.nombres senal["nombres"]
        json.direccion senal["direccion"]
        json.barrio senal["barrio"]
        json.zona senal["zona"]
        json.telefono1 senal["telefono1"]
        json.saldo 
        json.ultimo_pago 
        json.fechacontrato senal["fechacontrato"]
        json.fecha_ult_pago senal["fecha_ult_pago"]
        json.estado_int senal["estado_int"]
        json.saldo_int senal["saldo_int"]
        json.direccionip senal["direccionip"]
        json.velocidad senal["velocidad"]
        json.mac senal["mac1"]
        json.serialm senal["serialm"]
        json.ordenes do
            json.array! @instalaciones do |instalacion|
                if instalacion["concepto_id"] == 12 && instalacion["entidad_id"] == senal["id"]
                    json.inst_int instalacion["fechaven"]
                end
            end
            json.array! @cortes do |corte|
                if corte["concepto_id"] == 8 && corte["entidad_id"] == senal["id"]
                    json.corte_int corte["fechaven"]
                end
            end
            json.array! @traslados do |traslado|
                if traslado["concepto_id"] == 14 && traslado["entidad_id"] == senal["id"]
                    json.traslado_int traslado["fechaven"]
                end
            end
            json.array! @reconexiones do |rco|
                if rco["concepto_id"] == 16 && rco["entidad_id"] == senal["id"]
                    json.rco_int rco["fechaven"]
                end
            end
        end
    end
end
