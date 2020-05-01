class EndAfterStartValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        #バリデーションつけるのはend_timeのみ
        #timeのゲッターをオーバーライドしている前提
        #timeのゲッター呼び出し→dateの日付でtimeが呼ばれる
        #上記仕様でないとうまく動作しない
        start_time = record.start_time
        return unless start_time
        unless start_time < value
            record.errors.add(attribute, (options[:message] || I18n.t('errors.messages.before_start')))
        end
    end
end