json.senales do
    json.merge! @senal
end

json.info_internet do
    json.array! @info_internet do |internet|
        if (internet.senal_id == @senal.id)
            json.direccionip internet.direccionip
            json.velocidad internet.velocidad
            json.mac1 internet.mac1
            json.mac2 internet.mac2
            json.serialm internet.serialm
            json.marcam internet.marcam
            json.mascarasub internet.mascarasub
            json.dns internet.dns
            json.gateway internet.gateway
            json.nodo internet.nodo
            json.clavewifi internet.clavewifi
            json.equipo internet.equipo
        end
    end
end
