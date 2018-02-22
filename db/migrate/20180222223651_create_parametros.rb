class CreateParametros < ActiveRecord::Migration[5.1]
  def up
    create_table :parametros do |t|
      t.string :descripcion, limit: 80
      t.string :valor, limit: 100
    end
  end

  def down
    drop_table :parametros
  end
end
