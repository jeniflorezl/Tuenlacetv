class Orden < ApplicationRecord
  belongs_to :entidad
  belongs_to :concepto
  belongs_to :estado
  belongs_to :usuario

  validates :entidad, :concepto, :nrorden, :estado, :usuario, presence: true #obligatorio

  private

  def self.generar_orden(entidad_id, concepto_id, fechatrn, fechaven, valor, detalle, observacion, tecnico_id, 
    solicita, usuario_id)
    observacion = observacion.upcase! unless observacion == observacion.upcase
    consecutivos = Parametro.find_by(descripcion: 'Maneja consecutivos separados').valor
    if consecutivos == 'S'
      query = <<-SQL 
      SELECT MAX(nrorden) as ultimo FROM ordenes WHERE concepto_id=#{concepto_id};
      SQL
    else
      query = <<-SQL 
      SELECT MAX(nrorden) as ultimo FROM ordenes;
      SQL
    end
    Orden.connection.clear_query_cache
    ultimo = Orden.connection.select_all(query)
    if ultimo[0]["ultimo"] == nil
      ultimo=1
    else
      ultimo = (ultimo[0]["ultimo"]).to_i + 1
    end
    orden = Orden.new(entidad_id: entidad_id, concepto_id: concepto_id, fechatrn: fechatrn, fechaven: fechaven,
      nrorden: ultimo, estado_id: 6, observacion: observacion, tecnico_id: tecnico_id, usuario_id: usuario_id)
  end
end
