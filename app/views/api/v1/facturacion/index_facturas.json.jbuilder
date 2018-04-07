json.detalle_facturas do
    json.array! @detalle_facts do |d|
        json.concepto d["concepto"]
        json.descripcion d["desc"]
        json.nrodcto d["nrodcto"]
        json.fechatrn d["fechatrn"]
        json.fechaven d["fechaven"]
        json.valor d["valor"]
        json.iva d["iva"]
        json.saldo d["saldo"]
    end
end