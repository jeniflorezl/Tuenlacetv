json.senales do
    json.array! @senales do |senal|
        json.id senal["id"]
        json.tipo_documento senal["tipo_documento"]
        json.documento senal["documento"]  
        json.nombres senal["nombres"]
        json.nombre1 senal["nombre1"]
        json.nombre2 senal["nombre2"]
        json.apellido1 senal["apellido1"]
        json.apellido2 senal["apellido2"]
        json.direccionP senal["direccionP"]
        json.barrioP senal["barrioP"]
        json.zonaP senal["zonaP"]
        json.telefono1P senal["telefono1P"]
        json.telefono2P senal["telefono2P"]
        json.correo senal["correo"]
        json.fechanac senal["fechanac"]
        json.tipopersona senal["tipopersona"]
        json.estratoP senal["estratoP"]
        json.condicion_fisica senal["condicionfisica"]
        json.contrato senal["contrato"]
        json.direccion senal["direccion"]
        json.urbanizacion senal["urbanizacion"]
        json.torre senal["torre"]
        json.apto senal["apto"]
        json.barrio senal["barrio"]
        json.zona senal["zona"]
        json.telefono1 senal["telefono1"]
        json.telefono2 senal["telefono2"]
        json.contacto senal["contacto"]
        json.estrato senal["estrato"]
        json.vivienda senal["vivienda"]
        json.observacion senal["observacion"]
        json.fechacontrato senal["fechacontrato"]
        json.permanencia senal["permanencia"]
        json.televisores senal["televisores"]
        json.decos senal["decos"]
        json.precinto senal["precinto"]
        json.vendedor_id senal["vendedor_id"]
        json.vendedor senal["vendedor"]
        json.tipo_instalacion senal["tipo_instalacion"]
        json.tecnologia senal["tecnologia"]
        json.tiposervicio senal["tiposervicio"]
        json.areainstalacion senal["areainstalacion"]
        json.funcion senal["funcion_id"]
        json.tipo_facturacion senal["tipo_facturacion"]
        json.tecnico_id senal["tecnico_id"]
        json.tecnico senal["tecnico"]
        json.tv senal["tv"]
        json.plan_tv senal["plan_tv"]
        json.tarifa_tv senal["tarifa_tv"]
        json.estado_tv senal["estado_tv"]
        json.saldo_tv senal["saldo_tv"]
        json.fecha_ult_pago senal["fecha_ult_pago"]
        json.internet senal["internet"]
        if senal["internet"] == "1"
            json.direccionip senal["direccionip"]
            json.velocidad senal["velocidad"]
            json.mac1 senal["mac1"]
            json.mac2 senal["mac2"]
            json.serialm senal["serialm"]
            json.marcam senal["marcam"]
            json.mascarasub senal["mascarasub"]
            json.dns senal["dns"]
            json.gateway senal["gateway"]
            json.nodo senal["nodo"]
            json.clavewifi senal["clavewifi"]
            json.equipo senal["equipo"]
            json.plan_int senal["plan_int"]
            json.tarifa_int senal["tarifa_int"]
            json.estado_int senal["estado_int"]
            json.saldo_int senal["saldo_int"]
        end
    end
end

json.servicios do
    json.array! @servicios do |servicio|
        json.id servicio.id
        json.nombre servicio.nombre
    end
end

json.barrios do
    json.array! @barrios do |barrio|
        json.id barrio.id
        json.zona barrio.zona.nombre
        json.nombre barrio.nombre
    end
end

json.zonas do
    json.array! @zonas do |zona|
        json.id zona.id
        json.ciudad zona.ciudad.nombre
        json.nombre zona.nombre
    end
end

json.ciudades do
    json.array! @ciudades do |ciudad|
        json.id ciudad.id
        json.pais ciudad.pais.nombre
        json.nombre ciudad.nombre
        json.codigoDane ciudad.codigoDane
        json.codigoAlterno ciudad.codigoAlterno
        json.departamento ciudad.departamento.nombre
    end
end

json.planes_tv do
    json.array! @planes_tv do |plan|
        json.id plan.id
        json.nombre plan.nombre
    end
end

json.planes_int do
    json.array! @planes_int do |plan|
        json.id plan.id
        json.nombre plan.nombre
    end
end

json.tarifas_tv do
    json.array! @tarifas do |tarifa|
        if tarifa.plan.servicio_id == 1
            json.id tarifa.id
            json.zona tarifa.zona.nombre
            json.concepto tarifa.concepto.nombre
            json.plan_id tarifa.plan.id
            json.plan tarifa.plan.nombre
            json.valor tarifa.valor
            json.estado tarifa.estado.nombre
        end
    end
end
json.valor_afi_tv @valor_afi_tv
json.param_valor_afi @param_valor_afi

json.tarifas_int do
    json.array! @tarifas do |tarifa|
        if tarifa.plan.servicio_id == 2
            json.id tarifa.id
            json.zona tarifa.zona.nombre
            json.concepto tarifa.concepto.nombre
            json.plan_id tarifa.plan.id
            json.plan tarifa.plan.nombre
            json.valor tarifa.valor
            json.estado tarifa.estado.nombre
        end
    end
end
json.valor_afi_int @valor_afi_int

json.tipo_instalaciones do
    json.array! @tipo_instalaciones do |tipo_instalacion|
        json.id tipo_instalacion.id
        json.nombre tipo_instalacion.nombre
    end
end

json.tecnologias do
    json.array! @tecnologias do |tecnologias|
        json.id tecnologias.id
        json.nombre tecnologias.nombre
    end
end

json.tipo_documentos do
    json.array! @tipo_documentos do |tipo_documentos|
        json.id tipo_documentos.id
        json.nombre tipo_documentos.nombre
    end
end

json.funciones do
    json.array! @funciones do |funciones|
        json.id funciones.id
        json.nombre funciones.nombre
    end
end

json.vendedores do
    json.array! @vendedores do |vendedor|
        json.id vendedor.id
        if vendedor.persona.nombre2.blank?
            json.nombres vendedor.persona.nombre1 + ' ' + vendedor.persona.apellido1 + ' ' + vendedor.persona.apellido2
        else
            json.nombres vendedor.persona.nombre1 + ' ' + vendedor.persona.nombre2 + ' ' + vendedor.persona.apellido1 + ' ' + vendedor.persona.apellido2
        end
    end
end

json.tecnicos do
    json.array! @tecnicos do |tecnico|
        json.id tecnico.id
        if tecnico.persona.nombre2.blank?
            json.nombres tecnico.persona.nombre1 + ' ' + tecnico.persona.apellido1 + ' ' + tecnico.persona.apellido2
        else
            json.nombres tecnico.persona.nombre1 + ' ' + tecnico.persona.nombre2 + ' ' + tecnico.persona.apellido1 + ' ' + tecnico.persona.apellido2
        end
    end
end

json.tipo_facturacion do
    json.array! @tipo_facturacion do |tipo|
        json.id tipo.id
        json.nombre tipo.nombre
    end
end