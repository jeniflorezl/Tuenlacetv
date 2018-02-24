json.array! @ciudad do |ciudad|
    json.id ciudad.id
    json.pais ciudad.pais.nombre
    json.nombre ciudad.nombre
    json.codigoDane ciudad.codigoDane
    json.codigoAlterno ciudad.codigoAlterno
end