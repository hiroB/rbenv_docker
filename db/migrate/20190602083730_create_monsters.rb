class CreateMonsters < ActiveRecord::Migration[5.2]
  def change
    create_table :monsters do |t|
      t.string :name
      t.integer :rare
      t.integer :having
      t.string :image
      t.integer :skill_id
      t.integer :leader_skill_id
      t.string :type1
      t.string :type2
      t.string :type3

      t.timestamps
    end
    add_index :monsters, :name
  end
end
