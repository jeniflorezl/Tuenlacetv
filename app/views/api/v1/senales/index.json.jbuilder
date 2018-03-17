json.senales do
    json.array! @senales do |senal|
        json.id senal.entidad.id
        json.tipo_documento senal.entidad.persona.tipo_documento.nombre
        json.documento senal.entidad.persona.documento
        json.nombres senal.entidad.persona.nombre1 + '' + senal.entidad.persona.nombre2 + ' ' + senal.entidad.persona.apellido1 + ' ' + senal.entidad.persona.apellido2
        json.nombre1 senal.entidad.persona.nombre1
        json.nombre2 senal.entidad.persona.nombre2
        json.apellido1 senal.entidad.persona.apellido1
        json.apellido2 senal.entidad.persona.apellido2
        json.direccionP senal.entidad.persona.direccion
        json.barrioP senal.entidad.persona.barrio.nombre
        json.zonaP senal.entidad.persona.zona.nombre
        json.telefono1P senal.entidad.persona.telefono1
        json.telefono2P senal.entidad.persona.telefono2
        json.correo senal.entidad.persona.correo
        json.fechanac senal.entidad.persona.fechanac
        json.tipopersona senal.entidad.persona.tipopersona
        json.estratoP senal.entidad.persona.estrato
        json.condicion_fisica senal.entidad.persona.condicionfisica
        json.contrato senal.contrato
        json.direccion senal.direccion
        json.urbanizacion senal.urbanizacion
        json.torre senal.torre
        json.apto senal.apto
        json.barrio senal.barrio.nombre
        json.zona senal.zona.nombre
        json.telefono1 senal.telefono1
        json.telefono2 senal.telefono2
        json.contacto senal.contacto
        json.estrato senal.estrato
        json.vivienda senal.vivienda
        json.observacion senal.observacion
        @tv = 0
        unless @plantillas_tv.blank?
            json.plantilla_fact_tv do
                json.array! @plantillas_tv do |plantilla|
                    if (plantilla.senal_id == senal.id)
                        json.plan_tv plantilla.tarifa.plan.nombre
                        json.tarifa_tv plantilla.tarifa.valor
                        json.estado_tv plantilla.estado.nombre
                        @tv = 1
                    end
                end
            end
        end
        json.tv @tv
        json.fechacontrato senal.fechacontrato
        json.permanencia senal.permanencia
        json.televisores senal.televisores
        json.decos senal.decos
        json.precinto senal.precinto
        json.vendedor do
            json.array! @entidades do |entidad|
                vendedor = senal.vendedor_id
                if (vendedor == entidad.id)
                    json.id entidad.id
                    json.nombres entidad.persona.nombre1 + '' + entidad.persona.nombre2 + ' ' + entidad.persona.apellido1 + ' ' + entidad.persona.apellido2
                end
            end
        end
        json.tipo_instalacion senal.tipo_instalacion.nombre
        json.tecnologia senal.tecnologia.nombre
        json.tiposervicio senal.tiposervicio
        json.areainstalacion senal.areainstalacion
        json.funcion senal.entidad.funcion.nombre
        json.tipo_facturacion do
            json.array! @tipo_facturacion do |tipo|
                if (tipo.id == senal.tipo_facturacion_id)
                    json.tipo senal.tipo_facturacion.nombre
                end
            end
        end
        @int = 0
        unless @info_internet.blank?
            json.info_internet do
                json.array! @info_internet do |internet|
                    if (internet.senal_id == senal.id)
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
                            unless @plantillas_int.blank?
                                json.array! @plantillas_int do |plantilla|
                                    if (plantilla.senal_id == senal.id)
                                        json.plan_int plantilla.tarifa.plan.nombre
                                        json.tarifa_int plantilla.tarifa.valor
                                        json.estado_int plantilla.estado.nombre
                                        @int = 1
                                    end
                                end
                            end
                        end
                    end
                end
            end     
        end
        json.int @int 
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
        if (tarifa.plan.servicio_id == 1)
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
        if (tarifa.plan.servicio_id == 2)
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
        json.nombres vendedor.persona.nombre1 + '' + vendedor.persona.nombre2 + ' ' + vendedor.persona.apellido1 + ' ' + vendedor.persona.apellido2
    end
end

json.tecnicos do
    json.array! @tecnicos do |tecnico|
        json.id tecnico.id
        json.nombres tecnico.persona.nombre1 + '' + tecnico.persona.nombre2 + ' ' + tecnico.persona.apellido1 + ' ' + tecnico.persona.apellido2
    end
end

json.tipo_facturacion do
    json.array! @tipo_facturacion do |tipo|
        json.id tipo.id
        json.nombre tipo.nombre
    end
end