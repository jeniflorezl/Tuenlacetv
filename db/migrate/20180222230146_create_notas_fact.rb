class CreateNotasFact < ActiveRecord::Migration[5.1]
  def up
    create_table :notas_fact do |t|
      t.references :zona, foreign_key: true, null:false
      t.datetime :fechaElaboracion, null:false
      t.datetime :fechaInicio, null:false
      t.datetime :fechaFin, null:false
      t.datetime :fechaVencimiento, null:false
      t.datetime :fechaCorte, null:false
      t.datetime :fechaPagosVen, null:false
      t.string :nota1, limit: 100
      t.string :nota2, limit: 100
      t.string :nota3, limit: 100
      t.string :nota4, limit: 100
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE notas_fact 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE notas_fact 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :notas_fact
  end
end
