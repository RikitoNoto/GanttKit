class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def update_no_save(attributes)
    attributes.each do |key, value|
      self[key] = value
    end
    self.valid?
  end
end
