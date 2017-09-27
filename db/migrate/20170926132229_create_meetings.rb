class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.integer :user_id
      t.string :name
      t.datetime :start_time

      t.timestamps null: false
    end
  end
end
