json.detalle_facturas do
    json.array! @detalle_facts do |d|
        json.concepto_id d["concepto_id"]
        json.concepto d["concepto"]
        json.descripcion d["desc"]
        json.nrodcto d["nrodcto"]
        json.fechatrn d["fechatrn"]
        json.fechaven d["fechaven"]
        json.valor d["valor"]
        json.iva d["iva"]
        json.saldo d["saldo"]
        json.abono d["abono"]
        json.total d["total"]
    end
end

json.valor_total @valor_total
json.param_cobradores @param_cobradores

json.documentos do
    json.array! @documentos do |documento|
        json.id documento.id
        json.abreviatura documento.abreviatura
    end
end

json.cobradores do
    json.array! @cobradores do |cobrador|
        json.id cobrador.id
        if cobrador.persona.nombre2.blank?
            json.nombres cobrador.persona.nombre1 + ' ' + cobrador.persona.apellido1 + ' ' + cobrador.persona.apellido2
        else
            json.nombres cobrador.persona.nombre1 + ' ' + cobrador.persona.nombre2 + ' ' + cobrador.persona.apellido1 + ' ' + cobrador.persona.apellido2
        end
    end
end

json.formas_pago do
    json.array! @formas_pago do |forma_pago|
        json.id forma_pago.id
        json.nombre forma_pago.nombre
    end
end

json.bancos do
    json.array! @bancos do |banco|
        json.id banco.id
        json.nombre banco.nombre
    end
end