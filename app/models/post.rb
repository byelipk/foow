class Post < ActiveRecord::Base
  # PERSON ASSOCIATIONS
  belongs_to :author, class_name: "Person", foreign_key: "person_id"

  # CONVERSATION ASSOCIATIONS
  belongs_to :conversation
  after_destroy do 
    Activity.where(subject_id: self.id).each do |a|
      a.destroy
    end
  end


  # CALLBACKS
  before_save :set_post_number
  after_create :create_activities

  def set_post_number
    self.post_number = self.conversation.posts.count + 1
  end

  private

  def create_activities
    case self.response_action
    when "question"
      create_activity_for_post("question")
    when "belief"
      create_activity_for_post("belief")
    when "freeform"
      create_activity_for_post("freeform")
    else 
      raise "What are you trying to pull?"
    end
  end

  def create_activity_for_post(type)
    Activity.create(
      subject: self,
      name: "new_#{type}",
      direction: "for",
      person: author
    )
  end
end
