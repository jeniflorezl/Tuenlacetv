json.senales do
    json.array! @senales do |senal|
        json.id senal.entidad.id
        json.tipo_documento senal.entidad.persona.tipo_documento.nombre
        json.documento senal.entidad.persona.documento
        json.nombres senal.entidad.persona.nombre1 + '' + senal.entidad.persona.nombre2 + ' ' + senal.entidad.persona.apellido1 + ' ' + senal.entidad.persona.apellido2
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
        json.plantilla_tv do
            unless @plantillas.blank?
                json.array! @plantillas do |plantilla|
                    if (plantilla.senal_id == senal.id) and (plantilla.concepto_id == 1)
                        json.plan_tv plantilla.tarifa.plan.nombre
                        json.tarifa_tv plantilla.tarifa.nombre
                        json.estado_tv plantilla.estado.nombre
                    end
                end
            end
        end
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
                    json.plantilla_int do
                        unless @plantillas.blank?
                            json.array! @plantillas do |plantilla|
                                if (plantilla.senal_id == senal.id) and (plantilla.concepto_id == 2)
                                    json.plan_int plantilla.tarifa.plan.nombre
                                    json.tarifa_int plantilla.tarifa.nombre
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
            json.plan tarifa.plan.nombre
            json.valor tarifa.valor
            json.estado tarifa.estado.nombre
        end
    end
end

json.tarifas_int do
    json.array! @tarifas do |tarifa|
        if (tarifa.plan.servicio_id == 2)
            json.id tarifa.id
            json.zona tarifa.zona.nombre
            json.concepto tarifa.concepto.nombre
            json.plan tarifa.plan.nombre
            json.valor tarifa.valor
            json.estado tarifa.estado.nombre
        end
    end
end

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
        json.tipo_documento vendedor.persona.tipo_documento.nombre
        json.documento vendedor.persona.documento
        json.nombres vendedor.persona.nombre1 + '' + vendedor.persona.nombre2 + ' ' + vendedor.persona.apellido1 + ' ' + vendedor.persona.apellido2
        json.direccion vendedor.persona.direccion
        json.telefono1 vendedor.persona.telefono1
        json.telefono2 vendedor.persona.telefono2
        json.barrio vendedor.persona.barrio.nombre
        json.zona vendedor.persona.zona.nombre
        json.correo vendedor.persona.correo
        json.fechanac vendedor.persona.fechanac
        json.tipopersona vendedor.persona.tipopersona
        json.estrato vendedor.persona.estrato
    end
end

json.tecnicos do
    json.array! @tecnicos do |tecnico|
        json.id tecnico.id
        json.tipo_documento tecnico.persona.tipo_documento.nombre
        json.documento tecnico.persona.documento
        json.nombres tecnico.persona.nombre1 + '' + tecnico.persona.nombre2 + ' ' + tecnico.persona.apellido1 + ' ' + tecnico.persona.apellido2
        json.direccion tecnico.persona.direccion
        json.telefono1 tecnico.persona.telefono1
        json.telefono2 tecnico.persona.telefono2
        json.barrio tecnico.persona.barrio.nombre
        json.zona tecnico.persona.zona.nombre
        json.correo tecnico.persona.correo
        json.fechanac tecnico.persona.fechanac
        json.tipopersona tecnico.persona.tipopersona
        json.estrato tecnico.persona.estrato
    end
end