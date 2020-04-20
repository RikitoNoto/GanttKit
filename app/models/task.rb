class Task < ApplicationRecord
  has_many :user_tasks
  has_many :users, through: :user_tasks
  has_many :plans
  has_many :progress
  belongs_to :work

  validates :name, presence: true
  validates :start_date, presence: true
  validates :start_time, presence: true
  validates :end_date, presence: true
  validates :end_time, presence: true
  validates :quantity, presence: true

  def calendar_title_link(user: nil)
      return "/users/#{user.id}/tasks/#{self.id}"#タスクの詳細に飛ぶ
  end
end
