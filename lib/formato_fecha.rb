module FormatoFecha
    def formato_fecha(f)
        fecha_date = Date.parse f.to_s
        mes_f = fecha_date.month.to_s
        ano_f = fecha_date.year.to_s
        dia_f = fecha_date.day.to_s
        if mes_f.length == 1
          mes_f = '0' + mes_f
        end
        if dia_f.length == 1
          dia_f = '0' + dia_f
        end
        fecha = dia_f + '/' + mes_f + '/' + ano_f
        fecha
      end    
end