class AddHtmlContentToAuteurs < ActiveRecord::Migration
  def change
    add_column :auteurs, :html_content, :text
    add_column :poemes, :html_content, :text
  end
end
