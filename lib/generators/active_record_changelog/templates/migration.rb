class CreateChangelogs < ActiveRecord::Migration                                                                                                                                                                                          
  def self.up
    create_table :changelogs do |t| 
      t.string :item_type
      t.integer :item_id
      t.text :fields_changed
      t.text :summary
      t.string :changer

      t.timestamps
    end 

    add_index :changelogs, [:item_type, :item_id]
  end 

  def self.down
    drop_table :changelogs
  end 
end
