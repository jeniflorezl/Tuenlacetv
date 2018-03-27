json.entidades do
    json.array! @persona do |persona|
        json.array! @entidades do |entidad|
            if entidad.persona_id == persona.id
                json.id entidad.id
                json.tipo_documento persona.tipo_documento.nombre
                json.documento persona.documento
                json.nombres persona.nombre1 + '' + persona.nombre2 + ' ' + persona.apellido1 + ' ' + persona.apellido2
                json.nombre1 persona.nombre1
                json.nombre2 persona.nombre2
                json.apellido1 persona.apellido1
                json.apellido2 persona.apellido2
                json.direccionP persona.direccion
                json.barrioP persona.barrio.nombre
                json.zonaP persona.zona.nombre
                json.telefono1P persona.telefono1
                json.telefono2P persona.telefono2
                json.correo persona.correo
                json.fechanac persona.fechanac
                json.tipopersona persona.tipopersona
                json.estratoP persona.estrato
                json.condicion_fisica persona.condicionfisica
            end
        end
    end
end