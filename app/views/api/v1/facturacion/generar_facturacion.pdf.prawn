prawn_document do |pdf|
    pdf.stroke_axis
    pdf.line_width = 0.6 
    pdf.move_down 4
    pdf.stroke do
        pdf.rounded_rectangle [650, 300], 100, 30, 10
    end
    pdf.move_down 20
    pdf.rectangle [0, 300], 300, 300
    pdf.stroke { pdf.line [0, 100], [100, 100] }
end