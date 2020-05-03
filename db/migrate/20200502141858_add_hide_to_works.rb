class AddHideToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :display, :boolean, default: true
  end
end
