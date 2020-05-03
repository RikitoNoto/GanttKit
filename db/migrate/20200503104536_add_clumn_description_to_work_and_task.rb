class AddClumnDescriptionToWorkAndTask < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :description, :text
    add_column :tasks, :description, :text
  end
end
