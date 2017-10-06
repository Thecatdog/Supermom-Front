class CreateVaccinations < ActiveRecord::Migration
  def change
    create_table :vaccinations do |t|
      t.string :disease
      t.string :vaccine_value
      t.string :age
      t.string :vaccination_count
      t.string :order
      t.string :other

      t.timestamps null: false
    end
  end
end
