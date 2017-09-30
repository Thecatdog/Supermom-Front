class CreateCrawlers < ActiveRecord::Migration
  def change
    create_table :crawlers do |t|
      t.string :blog_title
      t.text :blog_s_title
      t.text :tag
      t.string :blog_link
      t.timestamps null: false
    end
  end
end
