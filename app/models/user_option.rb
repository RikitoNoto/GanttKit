class UserOption < ApplicationRecord
    belongs_to :user
    has_many :holidays
    accepts_nested_attributes_for :holidays
end
