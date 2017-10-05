class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :keyword
      t.integer :crawler_id
      t.timestamps null: false
    end
  end
end
