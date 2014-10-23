class AddImageUrlToAuteurs < ActiveRecord::Migration
  def change
    add_column :auteurs, :image_url, :text
  end
end
