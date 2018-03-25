json.departamentos do
    json.array! @departamentos do |departamento|
        json.id departamento.id
        json.pais departamento.pais.nombre
        json.nombre departamento.nombre
        json.codigo departamento.codigo
    end
end

json.paises do
    json.array! @paises do |pais|
        json.id pais.id
        json.nombre pais.nombre
    end
end