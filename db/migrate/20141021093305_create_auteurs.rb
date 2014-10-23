class CreateAuteurs < ActiveRecord::Migration
  def change
    create_table :auteurs do |t|
      t.string :name
      t.text :description
      t.text :description_source
      t.date :birth_date
      t.date :death_date
      t.integer :poemes_count, :null => false, :default => 0
      t.integer :century
      t.string :first_letter
      t.string :slug
      t.string :country

      t.timestamps
    end
  end
end
