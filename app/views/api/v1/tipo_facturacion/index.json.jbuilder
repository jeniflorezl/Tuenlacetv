json.tipo_facturacion do
    json.array! @tipo_facturacion do |tipo|
        json.id tipo.id
        json.nombre tipo.nombre
    end
end