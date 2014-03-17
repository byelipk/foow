class User < ActiveRecord::Base
  has_one :person
  has_one :profile, through: :person
end
