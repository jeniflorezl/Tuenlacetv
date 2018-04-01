prawn_document do |pdf|
    pdf.text "Hello World"
    pdf.table @documentos.collect{|d| [d.id,d.nombre]}
    pdf.move_to [100,50]
    pdf.line [100,100], [200,250]
    pdf.circle [100,100], 25
end