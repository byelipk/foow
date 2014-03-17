class HomeController < ApplicationController
  def index
    @activities = current_person.activity_feed 
  end
  
  def current_person
    Person.find(1)
  end
end
