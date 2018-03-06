module NombreMeses
  def mes(nombre)
    case nombre
      when "January"
        nombre = "ENERO"
      when "February"
        nombre = "FEBRERO"
      when "March"
        nombre = "MARZO"
      when "April"
        nombre = "ABRIL"
      when "May"
        nombre = "MAYO"
      when "June"
        nombre = "JUNIO"
      when "July"
        nombre = "JULIO"
      when "August"
        nombre = "AGOSTO"
      when "September"
        nombre = "SEPTIEMBRE"
      when "October"
        nombre = "OCTUBRE"
      when "November"
        nombre = "NOVIEMBRE"
      else "December"
        nombre = "DICIEMBRE"
    end
  end
end