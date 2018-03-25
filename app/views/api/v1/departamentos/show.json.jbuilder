json.departamentos do
    json.array! @departamento do |departamento|
        json.id departamento.id
        json.pais_id departamento.pais_id
        json.nombre departamento.nombre
        json.codigo departamento.codigo
    end
end