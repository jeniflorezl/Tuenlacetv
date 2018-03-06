json.departamentos do
    json.array! @departamento do |departamento|
        json.id departamento.id
        json.nombre departamento.nombre
        json.codigo departamento.codigo
    end
end