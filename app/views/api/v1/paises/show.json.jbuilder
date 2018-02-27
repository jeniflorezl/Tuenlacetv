json.paises do
    json.array! @pais do |pais|
        json.id pais.id
        json.nombre pais.nombre
    end
end