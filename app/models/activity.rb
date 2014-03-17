class Activity < ActiveRecord::Base
  belongs_to :subject, polymorphic: true
  belongs_to :person

  FOLLOWED_IDS = "SELECT followed_id FROM relationships 
                  WHERE follower_id = :person_id"

  def self.recent_global_activities(person)
    where("person_id IN (#{FOLLOWED_IDS})", person_id: person.id)
     .order("created_at DESC")
  end
end
