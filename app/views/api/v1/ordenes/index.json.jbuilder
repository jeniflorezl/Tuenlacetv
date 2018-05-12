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
        json.precinto orden["precinto"]
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
        json.tecnico orden["tecnico"]
        json.estado orden["estado"]
        json.valor orden["valor"]
        json.observacion orden["observacion"]
        json.detalle do
            json.array! @detalle_orden do |d|
                if d.orden_id == orden["id"]
                    json.grupo d.articulo.grupo.descripcion
                    json.articulo d.articulo.nombre
                    json.valor d.valor
                    json.cantidad d.cantidad
                    json.porIva d.porcentajeIva
                    json.iva d.iva
                    json.total d.costo
                end
            end
        end
    end
end

json.grupos do
    json.array! @grupos do |grupo|
        json.id grupo.id
        json.descripcion grupo.descripcion
    end
end

json.articulos do
    json.array! @articulos do |articulo|
        json.id articulo.id
        json.grupo_id articulo.grupo_id
        json.nombre articulo.nombre
        json.costo articulo.costo
        json.porcentajeIva articulo.porcentajeIva
    end
end

json.param_instalacion @param_instalacion 
json.param_corte @param_corte
json.param_rco @param_rco
json.param_retiro @param_retiro