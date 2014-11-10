class AddCenturyToAuteurs < ActiveRecord::Migration
  def change
    add_column :auteurs, :century_float, :float
  end
end
