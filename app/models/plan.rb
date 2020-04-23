class Plan < ApplicationRecord
  include Calendar
  belongs_to :user
  belongs_to :task

  validates :quantity, presence: true
  validates :time, presence: true
  validates :start_date, presence: true
  validates :start_time, presence: true
end
