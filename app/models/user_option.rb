class UserOption < ApplicationRecord
    belongs_to :user
    has_many :holidays
end
