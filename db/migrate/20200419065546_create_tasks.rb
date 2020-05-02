class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.float :quantity, null: false
      t.string :unit
      t.float :time
      t.date :start_date, null: false
      t.time :start_time, null: false
      t.date :end_date, null: false
      t.time :end_time, null: false
      t.references :work, null: false, foreign_key: true

      t.timestamps
    end
  end
end
