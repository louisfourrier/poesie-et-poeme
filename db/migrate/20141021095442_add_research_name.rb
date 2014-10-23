class AddResearchName < ActiveRecord::Migration
  def change
    add_column :auteurs, :research_name, :text
    add_index :auteurs, :research_name
    add_index :auteurs, :slug
    
    add_column :poemes, :research_name, :text
    add_index :poemes, :research_name
    add_index :poemes, :slug
    add_column :poemes, :first_letter, :string
  end
end
