class AddDateStringToAuthor < ActiveRecord::Migration
  def change
    add_column :auteurs, :date_string, :string
  end
end
