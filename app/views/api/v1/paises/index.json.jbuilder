json.paises do
    json.array! @paises do |pais|
        json.id pais.id
        json.nombre pais.nombre
    end
end