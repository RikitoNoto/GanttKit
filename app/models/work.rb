class Work < ApplicationRecord
    has_many :user_works
    has_many :users, through: :user_works
    has_many :tasks

    validates :name, presence: true
    validates :start_date, presence: true
    validates :start_time, presence: true
    validates :end_date, presence: true
    validates :end_time, presence: true

    def calendar_title_link(user: nil)
        return "/users/#{user.id}/works/#{self.id}/tasks"
    end
end
