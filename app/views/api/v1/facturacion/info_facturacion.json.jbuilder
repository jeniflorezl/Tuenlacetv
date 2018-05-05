json.zonas do
    json.array! @zonas do |zona|
        json.id zona.id
        json.ciudad zona.ciudad.nombre
        json.nombre zona.nombre
    end
end

json.tipo_facturacion do
    json.array! @tipo_facturacion do |tipo|
        json.id tipo.id
        json.nombre tipo.nombre
    end
end

json.fecha_corte @fecha_corte
json.fecha_pagos_ven @fecha_pagos_ven