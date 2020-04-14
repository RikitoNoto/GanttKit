class CreateUserOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :user_options do |t|
      t.time :start, null: false, default: "9:00"
      t.time :end, null: false, default: "18:00"
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
