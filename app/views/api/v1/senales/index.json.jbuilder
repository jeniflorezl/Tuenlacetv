json.senales do
    json.array! @senales do |senal|
        json.id senal.entidad.id
        json.tipo_documento senal.entidad.persona.tipo_documento.nombre
        json.documento senal.entidad.persona.documento
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

        json.fechacontrato senal.fechacontrato
        json.permanencia senal.permanencia
        json.televisores senal.televisores
        json.decos senal.decos
        json.precinto senal.precinto
        json.vendedor do
            json.array! @entidades do |entidad|
                vendedor = senal.vendedor_id
                if (vendedor == entidad.id)
                    json.tipo_documento entidad.persona.tipo_documento.nombre
                    json.documento entidad.persona.documento
                    json.nombre1 entidad.persona.nombre1
                    json.nombre2 entidad.persona.nombre2
                    json.apellido1 entidad.persona.apellido1
                    json.apellido2 entidad.persona.apellido2
                    json.direccionP entidad.persona.direccion
                    json.telefono1P entidad.persona.telefono1
                    json.telefono2P entidad.persona.telefono2
                    json.barrioP entidad.persona.barrio.nombre
                    json.zonaP entidad.persona.zona.nombre
                    json.correo entidad.persona.correo
                    json.fechanac entidad.persona.fechanac
                    json.tipopersona entidad.persona.tipopersona
                    json.estratoP entidad.persona.estrato
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

json.tarifas do
    json.array! @tarifas do |tarifa|
        json.id tarifa.id
        json.zona tarifa.zona.nombre
        json.concepto tarifa.concepto.nombre
        json.plan tarifa.plan.nombre
        json.valor tarifa.valor
        json.estado tarifa.estado
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

json.estados do
    json.array! @estados do |estado|
        json.id estado.id
        json.nombre estado.nombre
    end
end

json.vendedores do
    json.array! @vendedores do |vendedor|
        json.tipo_documento vendedor.persona.tipo_documento.nombre
        json.documento vendedor.persona.documento
        json.nombre1 vendedor.persona.nombre1
        json.nombre2 vendedor.persona.nombre2
        json.apellido1 vendedor.persona.apellido1
        json.apellido2 vendedor.persona.apellido2
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