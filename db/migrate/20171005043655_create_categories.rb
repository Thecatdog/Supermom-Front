class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :keword
      t.integer :crawler_id
      t.timestamps null: false
    end
  end
end
