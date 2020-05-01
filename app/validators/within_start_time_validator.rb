class WithinStartTimeValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        parent = record.parent
        return unless value and parent
        unless parent.send(attribute) <= value
            record.errors.add(attribute, (options[:message] || I18n.t('errors.messages.more_parent', parent: I18n.t("activerecord.models.#{parent.model_name.to_s.downcase}"))))
        end
    end
end