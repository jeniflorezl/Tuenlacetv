prawn_document do |pdf|
    pdf.stroke_axis
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
    pdf.font_size 8
    pdf.stroke do
        pdf.rounded_rectangle  [380, 794], 160, 18, 3
        pdf.draw_text "FACTURA DE VENTA No", :at => [385, 782]
        pdf.draw_text @num, :at => [490, 782]
    end 
    pdf.stroke do
        pdf.font_size 7
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
        pdf.draw_text "Jeni", :at => [39, 717]
        pdf.draw_text "1020", :at => [47, 699]
        pdf.draw_text "Clla 1", :at => [44, 681]
        pdf.draw_text "Prado", :at => [35, 661]
        pdf.draw_text "medellin", :at => [36, 645]
        pdf.draw_text "Fecha corte servicio:", :at => [385, 717]
        pdf.draw_text "Teléfono:", :at => [385, 699]
        pdf.draw_text "Zona:", :at => [385, 681]
        pdf.draw_text "Código:", :at => [385, 661]
        pdf.draw_text "E-mail:", :at =>[385, 645]
        pdf.draw_text @f_corte, :at => [462, 717]
        pdf.draw_text "4503", :at => [420, 699]
        pdf.draw_text "General", :at => [410, 681]
        pdf.draw_text "1", :at => [415, 661]
        pdf.draw_text "jeni@", :at =>[415, 645]
    end 
    pdf.stroke do
        pdf.rounded_rectangle  [0, 634], 540, 187, 3
        pdf.horizontal_line 0, 540, :at => 622
        pdf.horizontal_line 0, 540, :at => 571
        pdf.horizontal_line 0, 540, :at => 559
        pdf.horizontal_line 0, 540, :at => 492
        pdf.vertical_line 632, 447, :at => 380
        pdf.vertical_line 632, 492, :at => 460
        pdf.draw_text "CANTIDAD", :at => [5, 625]
        pdf.draw_text "DESCRIPCIÓN DEL SERVICIO", :at => [130, 625]
        pdf.draw_text "VALOR UNITARIO", :at => [387, 625]
        pdf.draw_text "VALOR TOTAL", :at => [472, 625]
        pdf.draw_text "1", :at => [22, 610]
        pdf.draw_text "MENSUALIDAD ABRIL", :at => [139, 610]
        pdf.draw_text "50.000", :at => [408, 610]
        pdf.draw_text "50.000", :at => [486, 610]
        pdf.draw_text "Fecha ultimo pago: ", :at => [5, 596]
        pdf.draw_text "01/02/2018", :at => [78, 596]
        pdf.draw_text "$20.000", :at => [124, 596]
        pdf.draw_text "PAGA SUSCRIPCIÓN", :at => [156, 596]
        pdf.font_size 6
        pdf.draw_text "SON:", :at => [5, 563]
        pdf.draw_text "SESENTA MIL PESOS CON CERO CENTAVOS", :at => [23, 563]
        pdf.font_size 8
        pdf.font "Helvetica", :style => :bold
        pdf.draw_text "SUBTOTAL", :at => [384, 562]
        pdf.draw_text "DESCUENTO", :at => [384, 548]
        pdf.draw_text "I.V.A", :at => [384, 536]
        pdf.draw_text "TOTAL FACTURA", :at => [384, 524]
        pdf.draw_text "SALDO ANTERIOR", :at => [384, 512]
        pdf.draw_text "TOTAL A PAGAR", :at => [384, 500]
        pdf.font "Helvetica", :style => :normal
        pdf.draw_text "50.000", :at => [486, 562]
        pdf.draw_text "50.000", :at => [486, 548]
        pdf.draw_text "50.000", :at => [486, 536]
        pdf.draw_text "50.000", :at => [486, 524]
        pdf.draw_text "50.000", :at => [486, 512]
        pdf.draw_text "50.000", :at => [486, 500]
        pdf.font_size 7
        pdf.draw_text "La presente FACTURA DE VENTA se asimila en todos los efectos a la LETRA DE CAMBIO (Art 774 Numero 6 del", :at => [5, 550]
        pdf.draw_text "código de comercio. La firma puesta por tercero en representación, mandato u otra calidad similar a nombre del", :at => [5, 542]
        pdf.draw_text "comprador implica su obligación de acuerdo al art 640 del Cód de Com e igualmente es constancia de la prestación", :at => [5, 534]
        pdf.draw_text "real del servicio y entrega del material.", :at => [5, 526]
        pdf.vertical_line 492, 447, :at => 225
        pdf.draw_text "Sede Sur: Cll 108 21-10 Provenza Tel: (7)6816770", :at => [5, 482]
        pdf.draw_text "Sede Sur: Cll 108 21-10 Provenza Tel: (7)6816770", :at => [5, 472]
        pdf.draw_text "Sede Sur: Cll 108 21-10 Provenza Tel: (7)6816770", :at => [5, 462]
        pdf.draw_text "Sede Sur: Cll 108 21-10 Provenza Tel: (7)6816770", :at => [5, 452]
        pdf.font_size 8
        pdf.draw_text "FIRMA AUTORIZADA", :at => [260, 483]
        pdf.horizontal_line 238, 368, :at => 455
        pdf.draw_text "RECIBIMOS A CONFORMIDAD", :at => [402, 483]
        pdf.horizontal_line 396, 526, :at => 455
    end 
end