class AddReferenceUserToTaskParam < ActiveRecord::Migration[5.2]
  def change
    add_reference :task_names, :user, null: false, foreign_key: true
  end
end
