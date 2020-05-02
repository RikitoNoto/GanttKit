class TaskName < ApplicationRecord
    has_many :tasks
    has_many :task_params

    validates :name, presence: true

    def self.get_id(_name)
        record = self.find_by(name: _name)
        unless record
            record = self.new(name: _name)
            record.save
        end
        return record.id
    end
end
