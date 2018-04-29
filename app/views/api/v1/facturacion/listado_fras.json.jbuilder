json.fras_venta do
    json.array! @listado do |l|
        json.codigo l["entidad_id"]
        json.documento l["documento"]
        json.nombres l["nombres"]
        json.nrofact l["nrofact"]
        json.valor l["valor"]
        json.iva l["iva"]
        json.total l["total"]
        json.fecha l["fecha"]
        json.observacion l["observacion"]
    end
end