json.detalle_recibos do
    json.array! @listado do |l|
        json.codigo l["entidad_id"]
        json.documento l["documento"]
        json.nombres l["nombres"]
        json.valor l["valor"]
        json.dcto l["descuento"]
        json.total l["total"]
        json.nrorecibo l["nrorecibo"]
        json.mes l["mes"]
        json.nrofact l["nrofact"]
        json.observacion l["observacion"]
    end
end