class WorkDecorator < ApplicationDecorator
  delegate_all

  def start_time
    super.strftime("%H:%M:%S")
  end

  def end_time
    super.strftime("%H:%M:%S")
  end

  def display#なぜかこのメソッドだけ呼び出しされず、nilが返ってしまうため追加。原因不明
    object.display
  end
end
