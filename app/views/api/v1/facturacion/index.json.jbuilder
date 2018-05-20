json.facturaciones do
    json.array! @facturaciones do |f|
        json.nrofact_ini f['nrofact_ini']
        json.nrofact_fin f['nrofact_fin']
        json.fecha_elaboracion f['f_elaboracion']
        json.fecha_inicio f['f_inicio']
        json.fecha_fin f['f_fin']
        json.fecha_vence f['f_ven']
        json.fecha_corte f['f_corte']
    end
end