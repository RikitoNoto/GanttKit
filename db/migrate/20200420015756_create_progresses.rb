class CreateProgresses < ActiveRecord::Migration[5.2]
  def change
    create_table :progresses do |t|
      t.float :quantity, null: false
      t.time :float, null: false
      t.date :start_date, null: false
      t.time :start_time, null: false
      t.references :user, foreign_key: true, null: false
      t.references :task, foreign_key: true, null: false

      t.timestamps
    end
  end
end
