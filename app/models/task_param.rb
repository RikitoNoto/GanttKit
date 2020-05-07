class TaskParam < ApplicationRecord
  belongs_to :task_name
  validates :param, numericality: true
end
