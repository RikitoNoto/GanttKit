module GetterStartEndTime
  extend ActiveSupport::Concern
  included do
  end

  def start_date=(date)#dateだけ更新された場合にtimeの自動更新も行う
    super(date)
    if start_time
      start_time = start_time
    end
  end

  def start_time=(time)
    super(time) unless start_date
    date = start_date
    super(Time.new(date.year, date.month, date.day, time.hour, time.min, time.sec))
  end

  def start_time
    return nil unless super
    return nil unless start_date
    date = start_date
    return Time.new(date.year, date.month, date.day, super.hour, super.min, super.sec)
  end

  def end_date=(date)
    super(date)
    if end_time
      end_time = end_time
    end
  end

  def end_time=(time)
    super(time) unless end_date
    date = end_date
    super(Time.new(date.year, date.month, date.day, time.hour, time.min, time.sec))
  end

  def end_time
    return nil unless super
    return nil unless end_date
    date = end_date
    return Time.new(date.year, date.month, date.day, super.hour, super.min, super.sec)
  end
end