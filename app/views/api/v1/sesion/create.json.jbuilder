json.auth_token @auth_token
json.usuario_id @usuario1.id
json.nivel @usuario1.nivel

json.permisos do
    json.array! @permisos do |p|
        json.modulo p["modulo"]
        json.opcion p["opcion"]
        json.ver p["ver"]
    end
end