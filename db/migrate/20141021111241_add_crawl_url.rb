class AddCrawlUrl < ActiveRecord::Migration
  def change
    add_column :auteurs, :crawl_url, :text
    add_column :poemes, :crawl_url, :text
  end
end
