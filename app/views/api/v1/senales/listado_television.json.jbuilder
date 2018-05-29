json.senales_tv do
    json.array! @senales do |senal|
        json.codigo senal["id"]
        json.documento senal["documento"]
        json.nombres senal["nombres"]
        json.direccion senal["direccion"]
        json.barrio senal["barrio"]
        json.zona senal["zona"]
        json.telefono1 senal["telefono1"]
        json.fechacontrato senal["fechacontrato"]
        json.fecha_ult_pago senal["fecha_ult_pago"]
        json.estado_tv senal["estado_tv"]
        json.saldo_tv senal["saldo_tv"]
        json.instalacion_tv senal["instalacion_tv"]
        json.corte_tv senal["corte_tv"]
        json.traslado_tv senal["traslado_tv"]
        json.reco_tv senal["reco_tv"]
    end
end