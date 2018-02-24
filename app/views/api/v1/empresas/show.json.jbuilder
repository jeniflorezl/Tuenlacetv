json.empresas do
    json.array! @empresas do |empresa|
        json.id empresa.id
        json.tipo empresa.tipo
        json.nit empresa.nit
        json.razonsocial empresa.razonsocial
        json.direccion empresa.direccion
        json.telefono1 empresa.telefono1
        json.telefono2 empresa.telefono2
        json.ciudad empresa.ciudad.nombre
        json.representante do 
            json.array! @entidades do |entidad|
                representante = empresa.entidad_id
                if (representante == entidad.id)
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
        json.logoempresa empresa.logo
        json.correo empresa.correo
        json.regimen empresa.regimen
        json.contribuyente empresa.contribuyente
        json.centrocosto empresa.centrocosto
    end
end