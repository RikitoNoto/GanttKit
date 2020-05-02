class AddAssosiationToTasks < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :task_name, null: false, foreign_key: true
    add_reference :task_params, :task_name, null: false, foreign_key: true
  end#タスクネームテーブルを後に作っているのでここで追加している
end
