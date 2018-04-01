json.entidades do
    json.array! @entidades do |entidad|
        json.id entidad["id"]
        json.tipo_documento entidad["tipo_documento"]
        json.documento entidad["documento"]  
        json.nombres entidad["nombres"]
        json.nombre1 entidad["nombre1"]
        json.nombre2 entidad["nombre2"]
        json.apellido1 entidad["apellido1"]
        json.apellido2 entidad["apellido2"]
        json.direccionP entidad["direccionP"]
        json.barrioP entidad["barrioP"]
        json.zonaP entidad["zonaP"]
        json.telefono1P entidad["telefono1P"]
        json.telefono2P entidad["telefono2P"]
        json.correo entidad["correo"]
        json.fechanac entidad["fechanac"]
        json.tipopersona entidad["tipopersona"]
        json.estratoP entidad["estratoP"]
        json.condicion_fisica entidad["condicionfisica"]
        if @funcion == "1"
            json.contrato entidad["contrato"]
            json.direccion entidad["direccion"]
            json.urbanizacion entidad["urbanizacion"]
            json.torre entidad["torre"]
            json.apto entidad["apto"]
            json.barrio entidad["barrio"]
            json.zona entidad["zona"]
            json.telefono1 entidad["telefono1"]
            json.telefono2 entidad["telefono2"]
            json.contacto entidad["contacto"]
            json.estrato entidad["estrato"]
            json.vivienda entidad["vivienda"]
            json.observacion entidad["observacion"]
            json.fechacontrato entidad["fechacontrato"]
            json.permanencia entidad["permanencia"]
            json.televisores entidad["televisores"]
            json.decos entidad["decos"]
            json.precinto entidad["precinto"]
            json.vendedor_id entidad["vendedor_id"]
            json.vendedor entidad["vendedor"]
            json.tipo_instalacion entidad["tipo_instalacion"]
            json.tecnologia entidad["tecnologia"]
            json.tiposervicio entidad["tiposervicio"]
            json.areainstalacion entidad["areainstalacion"]
            json.funcion entidad["funcion_id"]
            json.tipo_facturacion entidad["tipo_facturacion"]
            json.tecnico_id entidad["tecnico_id"]
            json.tecnico entidad["tecnico"]
            json.tv entidad["tv"]
            json.plan_tv entidad["plan_tv"]
            json.tarifa_tv entidad["tarifa_tv"]
            json.estado_tv entidad["estado_tv"]
            json.saldo_tv entidad["saldo_tv"]
            json.fecha_ult_pago entidad["fecha_ult_pago"]
            json.internet entidad["internet"]
            if entidad["internet"] == "1"
                json.direccionip entidad["direccionip"]
                json.velocidad entidad["velocidad"]
                json.mac1 entidad["mac1"]
                json.mac2 entidad["mac2"]
                json.serialm entidad["serialm"]
                json.marcam entidad["marcam"]
                json.mascarasub entidad["mascarasub"]
                json.dns entidad["dns"]
                json.gateway entidad["gateway"]
                json.nodo entidad["nodo"]
                json.clavewifi entidad["clavewifi"]
                json.equipo entidad["equipo"]
                json.plan_int entidad["plan_int"]
                json.tarifa_int entidad["tarifa_int"]
                json.estado_int entidad["estado_int"]
                json.saldo_int entidad["saldo_int"]
            end
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