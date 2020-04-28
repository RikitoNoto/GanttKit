class WithinStartTimeValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        parent = record.parent
        return unless value and parent
        unless parent.send(attribute) <= value
            record.errors.add(attribute, (options[:message] || "must be within parent's"))
        end
    end
end