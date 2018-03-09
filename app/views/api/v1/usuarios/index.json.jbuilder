json.usuarios do
    json.array! @usuarios do |usuario|
        json.id usuario.id
        json.login usuario.login
        json.nombre usuario.nombre
        json.nivel usuario.nivel
        json.estado usuario.estado.nombre
        json.tipoImpresora usuario.tipoImpresora
    end
end

json.estados do
    json.array! @estados do |estado|
        json.id estado.id
        json.nombre estado.nombre
    end
end