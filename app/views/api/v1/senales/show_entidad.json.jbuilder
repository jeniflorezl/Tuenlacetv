json.entidades do
    json.array! @entidad do |entidad|
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
    end
end