json.senales do
    json.array! @senal do |senal|
        json.id senal["id"]
        json.tipo_documento senal["tipo_documento"]
        json.documento senal["documento"]  
        if senal["nombre2"].blank?
            json.nombres senal["nombre1"] + ' ' + senal["apellido1"] + ' ' + senal["apellido2"]
        else
            json.nombres senal["nombre1"] + ' ' + senal["nombre2"] + ' ' + senal["apellido1"] + ' ' + senal["apellido2"]
        end
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
        json.decos senal["decps"]
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
        if senal["internet"] == "1"
            json.info_internet do
                json.array! @info_internet do |internet|
                    if (senal["senal_id"] == internet.senal_id)
                        json.direccionip internet.direccionip
                        json.velocidad internet.velocidad
                        json.mac1 internet.mac1
                        json.mac2 internet.mac2
                        json.serialm internet.serialm
                        json.marcam internet.marcam
                        json.mascarasub internet.mascarasub
                        json.dns internet.dns
                        json.gateway internet.gateway
                        json.nodo internet.nodo
                        json.clavewifi internet.clavewifi
                        json.equipo internet.equipo
                        json.internet senal["internet"]
                        json.plan_int senal["plan_int"]
                        json.tarifa_int senal["tarifa_int"]
                        json.estado_int senal["estado_int"]
                        json.saldo_int senal["saldo_int"]
                    end
                end
            end
        end
    end
end




