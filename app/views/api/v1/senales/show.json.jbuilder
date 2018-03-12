json.senales do
    json.array! @senal do |senal|
        json.id senal["id"]
        json.tipo_documento senal["tipo_documento"]
        json.documento senal["documento"]  
        json.nombres senal["nombre1"] + '' + senal["nombre2"] + '' + senal["apellido1"] + '' + senal["apellido2"]
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
        json.tipo_instalacion senal["tipo_instalacion"]
        json.tecnologia senal["tecnologia"]
        json.tiposervicio senal["tiposervicio"]
        json.areainstalacion senal["areainstalacion"]
        json.funcion senal["funcion_id"]
        @senales.each do |senales|
            if (senal["id"] == senales.entidad_id)
                json.plantilla_fact_tv do
                    json.array! @plantillas do |plantilla|
                        if (plantilla.senal_id == senales.id) and (plantilla.concepto_id == 3)
                            json.plan_tv plantilla.tarifa.plan.nombre
                            json.tarifa_tv plantilla.tarifa.valor
                            json.estado_tv plantilla.estado.nombre
                        end
                    end
                end
                json.info_internet do
                    json.array! @info_internet do |internet|
                        if (senales.id == internet.senal_id)
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
                            json.plantilla_fact_int do
                                json.array! @plantillas do |plantilla|
                                    if (plantilla.senal_id == senales.id) and (plantilla.concepto_id == 4)
                                        json.plan_int plantilla.tarifa.plan.nombre
                                        json.tarifa_int plantilla.tarifa.valor
                                        json.estado_int plantilla.estado.nombre
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end




