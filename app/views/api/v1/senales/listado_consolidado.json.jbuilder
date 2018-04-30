json.senales do
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
        json.estado_int senal["estado_int"]
        json.instalacion_tv senal["instalacion_tv"]
        json.corte_tv senal["corte_tv"]
        json.traslado_tv senal["traslado_tv"]
        json.reco_tv senal["reco_tv"]
        json.instalacion_int senal["instalacion_int"]
        json.corte_int senal["corte_int"]
        json.traslado_int senal["traslado_int"]
        json.rco_int senal["rco_int"]
    end
end
