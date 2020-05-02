class CreateTaskParams < ActiveRecord::Migration[5.2]
  def change
    create_table :task_params do |t|
      t.integer :order, null: false
      t.float :param, null: false

      t.timestamps
    end
  end
end
