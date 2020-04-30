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
    if time.to_time#timeがnilでなければ
      if start_date#start_dateがあればそれも含めて作成
        time = Time.parse(time.to_s)#文字列変換→perseでTime型のクラスに変換
        super(Time.new(start_date.year, start_date.month, start_date.day, time.hour, time.min, time.sec))
      else#start_dateがなければtimeだけ(2000/1/1)で作成
        super(time)
      end
    else#timeがnilだったらnil代入
      super(nil)
    end
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
    if time.to_time#timeがnilでなければ
      if end_date#end_dateがあればそれも含めて作成
        time = Time.parse(time.to_s)#文字列変換→perseでTime型のクラスに変換
        super(Time.new(end_date.year, end_date.month, end_date.day, time.hour, time.min, time.sec))
      else#end_dateがなければtimeだけ(2000/1/1)で作成
        super(time)
      end
    else#timeがnilだったらnil代入
      super(nil)
    end
  end

  def end_time
    return nil unless super
    return nil unless end_date
    date = end_date
    return Time.new(date.year, date.month, date.day, super.hour, super.min, super.sec)
  end
end