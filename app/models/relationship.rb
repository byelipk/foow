class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "Person"
  belongs_to :followed, class_name: "Person"

  after_create :create_activities
  after_destroy do 
    Activity.where(subject_id: self.id).each do |a|
      a.destroy
    end
  end

  private

  def create_activities
    create_activity_for_follower
    create_activity_for_followed
  end

  def create_activity_for_follower
    Activity.create(
      subject: self,
      name: "new_relationship",
      direction: "by",
      person: follower
    )
  end

  def create_activity_for_followed
    Activity.create(
      subject: self,
      name: "new_relationship",
      direction: "on",
      person: followed 
    )
  end
end
