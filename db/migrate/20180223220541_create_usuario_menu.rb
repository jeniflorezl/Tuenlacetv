class CreateUsuarioMenu < ActiveRecord::Migration[5.1]
  def up
    create_table :usuario_menu, {:id => false} do |t|
      t.varchar :modulo, limit:50, null:false
      t.varchar :opcion, limit:50, null:false
      t.references :usuario, foreign_key: true, null:false
      t.char :ver, limit:5, null:false
      t.varchar :titulo, limit:50
    end
    execute <<-SQL
    ALTER TABLE usuario_menu ADD PRIMARY KEY (modulo,opcion,usuario_id);
    SQL
  end

  def down
    drop_table :usuario_menu
  end
end
