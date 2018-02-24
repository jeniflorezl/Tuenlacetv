json.array! @usuario do |usuario|
    json.id usuario.id
    json.login usuario.login
    json.nombre usuario.nombre
    json.nivel usuario.nivel
end