json.array! @usuarios do |usuario|
    json.id usuario.id
    json.login usuario.login
    json.nombre usuario.nombre
    json.nivel usuario.nivel
    json.usuario usuario.user
end