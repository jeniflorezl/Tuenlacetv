prawn_document() do |pdf|
    @senales.each do |s|
        pdf.start_new_page
        pdf.font "Helvetica"
        pdf.font_size 7
        pdf.line_width = 0.6
        pdf.draw_text "Resolución Dian No 18762007285790", :at => [180, 788]
        pdf.draw_text "Fecha expedición 09 de Marzo de 2018", :at => [180, 778]
        pdf.draw_text "Numero habilitado del 71644 al 200000", :at => [180, 768]
        pdf.draw_text "Iva Régimen Común", :at => [180, 758]
        pdf.draw_text "Nit: 900548752-8", :at => [180, 748]
        pdf.draw_text "BUCARAMANGA-SANTANDER", :at => [180, 738]
        pdf.image "#{Prawn::DATADIR}/images/logo.JPG", :at => [3, 800], :width => 125, :height => 46
        pdf.draw_text "www.tvcolombiadigital.com", :at => [6, 734]
        pdf.stroke do
            pdf.rounded_rectangle  [380, 794], 160, 18, 3
            pdf.draw_text "FACTURA DE VENTA No", :at => [385, 782], :size => 8
        end 
        pdf.stroke do
            pdf.rounded_rectangle  [380, 772], 160, 38, 3
            pdf.horizontal_line 380, 540, :at => 760
            pdf.horizontal_line 380, 540, :at => 748
            pdf.vertical_line 772, 734, :at => 460
            pdf.draw_text "Fecha Factura", :at => [396, 763]
            pdf.draw_text "Fecha Vencimiento", :at => [469, 763]
            pdf.draw_text "Dia", :at => [388, 751]
            pdf.draw_text "Mes", :at => [412, 751]
            pdf.draw_text "Año", :at => [436, 751]
            pdf.draw_text @f_inicio_dia, :at => [388, 739]
            pdf.draw_text @f_inicio_mes, :at => [412, 739]
            pdf.draw_text @f_inicio_ano, :at => [436, 739]
            pdf.draw_text "Dia", :at => [467, 751]
            pdf.draw_text "Mes", :at => [491, 751]
            pdf.draw_text "Año", :at => [515, 751]
            pdf.draw_text @f_ven_dia, :at => [467, 739]
            pdf.draw_text @f_ven_mes, :at => [491, 739]
            pdf.draw_text @f_ven_ano, :at => [515, 739]
        end 
        pdf.font_size 8
        pdf.stroke do
            pdf.rounded_rectangle  [0, 730], 540, 90, 3
            pdf.horizontal_line 0, 540, :at => 712
            pdf.horizontal_line 0, 540, :at => 694
            pdf.horizontal_line 0, 540, :at => 676
            pdf.horizontal_line 0, 540, :at => 656
            pdf.vertical_line 730, 640, :at => 380
            pdf.draw_text "Nombre:", :at => [5, 717]
            pdf.draw_text "Cédula/Nit:", :at => [5, 699]
            pdf.draw_text "Dirección:", :at => [5, 681]
            pdf.draw_text "Barrio:", :at => [5, 661]
            pdf.draw_text "Ciudad:", :at => [5, 645]
            pdf.draw_text s["nombres"], :at => [39, 717]
            pdf.draw_text s["documento"], :at => [47, 699]
            pdf.draw_text s["direccion"], :at => [44, 681]
            pdf.draw_text s["barrio"], :at => [35, 661]
            pdf.draw_text @ciudad, :at => [36, 645]
            pdf.draw_text "Fecha corte servicio:", :at => [385, 717]
            pdf.draw_text "Teléfono:", :at => [385, 699]
            pdf.draw_text "Zona:", :at => [385, 681]
            pdf.draw_text "Código:", :at => [385, 661]
            pdf.draw_text "E-mail:", :at =>[385, 645]
            pdf.draw_text @f_corte, :at => [462, 717]
            pdf.draw_text s["telefono1"], :at => [420, 699]
            pdf.draw_text s["zona"], :at => [410, 681]
            pdf.draw_text s["id"], :at => [415, 661]
            pdf.draw_text s["correo"], :at =>[415, 645]
        end
        pdf.stroke do
            pdf.rounded_rectangle  [0, 634], 540, 187, 3
            pdf.horizontal_line 0, 540, :at => 622
            pdf.horizontal_line 0, 540, :at => 571
            pdf.horizontal_line 0, 540, :at => 559
            pdf.horizontal_line 0, 540, :at => 492
            pdf.vertical_line 634, 447, :at => 380
            pdf.vertical_line 634, 492, :at => 460
            pdf.draw_text "CANTIDAD", :at => [5, 625]
            pdf.draw_text "DESCRIPCIÓN DEL SERVICIO", :at => [130, 625]
            pdf.draw_text "VALOR UNITARIO", :at => [387, 625]
            pdf.draw_text "VALOR TOTAL", :at => [472, 625]
            if s["saldo_int"].blank?
                saldo = s["saldo_tv"]
            else
                saldo = s["saldo_tv"] + s["saldo_int"]
            end
            saldo_anterior = 0
            valor_total = 0
            valor_iva = 0
            descuento = 0
            total = 0
            y = 610 
            ban = 1
            @facturas.each do |f|
                if (s["id"] == f["entidad_id"])
                    pdf.draw_text f["prefijo"] + '' + f["id"].to_s, :at => [492, 782] if ban == 1
                    ban = 2
                    pdf.draw_text f["cantidad"], :at => [22, y]
                    pdf.draw_text f["observacion"], :at => [139, y]
                    pdf.draw_text number_to_currency((f["valor"].to_f).round, unit: ""), :at => [402, y]
                    pdf.bounding_box([482, y+6], :width => 50, :height => 500) do
                        pdf.text number_to_currency((f["valor"].to_f).round, unit: ""), :align => :right
                        pdf.move_down 2
                    end
                    valor_total += (f["valor"].to_f).round
                    valor_iva += (f["iva"].to_f).round
                    if f["descuento"].blank?
                        descuento += 0
                    end
                    y -= 10
                end
            end
            total = (valor_total + valor_iva) - descuento
            saldo_anterior = saldo - (total.to_f).round
            @ult_pagos.each do |p|
                if (s["id"] == p["entidad_id"])
                    pdf.draw_text "Fecha ultimo pago: ", :at => [5, 578]
                    pdf.draw_text p["fechatrn"], :at => [78, 578]
                    pdf.draw_text "$" + '' + p["valor"].to_s, :at => [124, 578]
                    pdf.draw_text p["observacion"], :at => [160, 578]
                end
            end
            pdf.draw_text "SON:", :at => [5, 563], :size => 6
            pdf.draw_text I18n.with_locale(:es) { total.to_words.upcase } + ' PESOS CON CERO CENTAVOS', :at => [23, 563], :size => 6
            pdf.font "Helvetica", :style => :bold
            pdf.draw_text "SUBTOTAL", :at => [384, 562]
            pdf.draw_text "DESCUENTO", :at => [384, 548]
            pdf.draw_text "I.V.A", :at => [384, 536]
            pdf.draw_text "TOTAL FACTURA", :at => [384, 524]
            pdf.draw_text "SALDO ANTERIOR", :at => [384, 512]
            pdf.draw_text "TOTAL A PAGAR", :at => [384, 500]
            pdf.font "Helvetica", :style => :normal
            pdf.bounding_box([482, 568], :width => 50, :height => 300) do
                pdf.text number_to_currency(valor_total, unit: ""), :align => :right
                pdf.move_down 5
                pdf.text number_to_currency(descuento, unit: ""), :align => :right
                pdf.move_down 2.2
                pdf.text number_to_currency(valor_iva, unit: ""), :align => :right
                pdf.move_down 2.5
                pdf.text number_to_currency(total, unit: ""), :align => :right
                pdf.move_down 3
                pdf.text number_to_currency(saldo_anterior, unit: ""), :align => :right
                pdf.move_down 2.9
                pdf.text number_to_currency(total, unit: ""), :align => :right, :style => :bold
            end
            pdf.font_size 7
            pdf.draw_text "La presente FACTURA DE VENTA se asimila en todos los efectos a la LETRA DE CAMBIO (Art 774 Numero 6 del", :at => [5, 550]
            pdf.draw_text "código de comercio. La firma puesta por tercero en representación, mandato u otra calidad similar a nombre del", :at => [5, 542]
            pdf.draw_text "comprador implica su obligación de acuerdo al art 640 del Cód de Com e igualmente es constancia de la prestación", :at => [5, 534]
            pdf.draw_text "real del servicio y entrega del material.", :at => [5, 526]
            pdf.vertical_line 492, 447, :at => 225
            pdf.draw_text "Sede Sur: Cll 108 21-10 Provenza Tel: (7)6816770", :at => [5, 482]
            pdf.draw_text "Sede Oeste: Cll 56 3W-106 Mutis Tel: (7)6419595", :at => [5, 474]
            pdf.draw_text "Sede Norte: Cll 17 12-31 Kennedy Tel:(7)6400616", :at => [5, 466]
            pdf.draw_text "Sede Centro: Cll 27 7-59 Girardot Tel:(7)6734371", :at => [5, 458]
            pdf.font_size 8
            pdf.draw_text "FIRMA AUTORIZADA", :at => [260, 483]
            pdf.horizontal_line 238, 368, :at => 455
            pdf.draw_text "RECIBIMOS A CONFORMIDAD", :at => [402, 483]
            pdf.horizontal_line 396, 526, :at => 455
        end 
    end
end