class CreateUsuarioMenu < ActiveRecord::Migration[5.1]
  def up
    create_table :usuario_menu, {:id => false} do |t|
      t.integer :nivel, limit: 3, null:false
      t.varchar :modulo, limit: 50, null:false
      t.varchar :opcion, limit: 50, null:false
      t.char :ver, limit: 5, null:false
      t.varchar :titulo, limit: 50
    end
  end

  def down
    drop_table :usuario_menu
  end
end
