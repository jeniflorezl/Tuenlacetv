json.senales do
    json.array! @senal do |senal|
        json.contrato senal["contrato"]
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
        json.precinto senal["precinto"]
        @senales.each do |senales|
            if (senal["id"] == senales.entidad_id)
                json.plantilla_fact_tv do
                    json.array! @plantillas do |plantilla|
                        if (plantilla.senal_id == senales.id) and (plantilla.concepto_id == 3)
                            json.estado_tv plantilla.estado.nombre
                        end
                    end
                    json.array! @saldos do |saldo|
                        if (senal["id"] == saldo["entidad_id"])
                            json.saldo_tv saldo["saldo_tv"]
                        end
                    end
                end
            end
        end
    end
end
