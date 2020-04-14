class Holiday < ApplicationRecord
    belongs_to :user_option
    #day 0:sun, 1:mon, 2:tue, 3:wed, 4:thu, 5:fri, 6:sat
    validates :day, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 6}#整数のみ
end
