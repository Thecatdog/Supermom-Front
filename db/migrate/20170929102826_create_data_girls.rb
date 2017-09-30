class CreateDataGirls < ActiveRecord::Migration
  def change
    create_table :data_girls do |t|
      t.string :baby_age
      t.string :baby_weight
      t.string :baby_height
      t.string :bmi
      t.string :baby_head_length
      
      t.timestamps null: false
    end
  end
end
