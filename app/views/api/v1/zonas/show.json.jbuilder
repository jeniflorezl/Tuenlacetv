json.zonas do
    json.array! @zona do |zona|
        json.id zona.id
        json.ciudad zona.ciudad.nombre
        json.nombre zona.nombre
    end
end