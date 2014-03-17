class Profile < ActiveRecord::Base
  # PERSON ASSOCIATIONS
  belongs_to :person

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
