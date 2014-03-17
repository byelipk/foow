class Person < ActiveRecord::Base
  # USER ASSOCIATIONS
  belongs_to :user

  # PROFILE ASSOCIATIONS
  has_one :profile

  # FOLLOWING ASSOCIATIONS
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", 
    class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  # ACTIVITY ASSOCIATIONS
  has_many :activities

  # POSTS ASSOCIATIONS
  has_many :posts

  # DELEGATIONS
  delegate :first_name, :last_name, :full_name, to: :profile 

  def recent_activities(limit=10)
    activities.order("created_at DESC").limit(limit)
  end

  def activity_feed
    Activity.recent_global_activities(self)
  end

  def following?(other_person)
    relationships.find_by(followed_id: other_person.id)
  end

  def follow!(other_person)
    relationships.create!(followed_id: other_person.id)
  end

  def unfollow!(other_person)
    relationships.find_by(followed_id: other_person.id).destroy
  end
end
