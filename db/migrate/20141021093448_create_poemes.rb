class CreatePoemes < ActiveRecord::Migration
  def change
    create_table :poemes do |t|
      t.string :title
      t.text :content
      t.text :recueil
      t.string :slug
      t.date :written_date
      t.references :auteur, index: true

      t.timestamps
    end
  end
end
