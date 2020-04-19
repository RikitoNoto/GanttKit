class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.float :quantity
      t.string :unit
      t.date :start_date
      t.time :start_time
      t.date :end_date
      t.time :end_time
      t.references :work, null: false, foreign_key: true

      t.timestamps
    end
  end
end
