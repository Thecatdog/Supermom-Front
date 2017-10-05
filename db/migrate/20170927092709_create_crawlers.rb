class CreateCrawlers < ActiveRecord::Migration
  def change
    create_table :crawlers do |t|
      t.string :blog_link
      t.integer :blog_id
      t.integer :category_id
      t.timestamps null: false
    end
  end
end
