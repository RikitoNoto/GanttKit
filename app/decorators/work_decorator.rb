class WorkDecorator < ApplicationDecorator
  delegate_all

  def start_time
    super.strftime("%H:%M:%S")
  end

  def end_time
    super.strftime("%H:%M:%S")
  end

end
