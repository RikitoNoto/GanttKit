class CreateHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :holidays do |t|
      t.integer :day, null: false
      t.references :user_option, null: false, foreign_key: true
      t.timestamps
    end
  end
end
