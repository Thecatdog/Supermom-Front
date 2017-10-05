class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :blog_link
      t.string :blog_title
      t.text :blog_s_content
      t.text :tag
      t.timestamps null: false
    end
  end
end
