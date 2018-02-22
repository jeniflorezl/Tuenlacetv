class CreateFormasPago < ActiveRecord::Migration[5.1]
  def up
    create_table :formas_pago do |t|
      t.varchar :nombre, limit: 20, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE formas_pago 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE formas_pago 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :formas_pago
  end
end
