class AfterStartDateValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      return unless record[:finish_at] && record[:started_at] && record[:started_at] > record[:finish_at]
      message = options[:message] || :cannot_be_after_end_at
      record.errors.add(:started_at, message)
      end
    end
  

