Fan Out on Write
================

This is just an example rails app using a fan out of write design for an
activity feed.

This design uses a polymorphic `activities` table. The following migration would
generate such a table:

    create_table :activities do |t|
        t.references :subject, polymorphic: true
        t.string  :name
        t.string  :direction
        t.integer :person_id
        t.timestamps
    end

This design materializes the activity feed on write (i.e. when a new resource is
created, a new activity corresponding to that resource is created). This is
often referred to as a "push" model or a "fanout" because a *producer's*
activities are propogated *OUT* to the  *consumers* of his/her activities.

The feed contains the ids of the activities themselves, making this
table *normalized*. Like everything there are several trade-offs: Since we're
only storing the id and name of the activity, the amount of data we're writing
to the database is relatively small. However, with a follower-based system like this one, 
the data can potentially be copied thousands or millions of times, increasing
the cost of reading the data.

When implemented on a PostgreSQL database, the "push" model is fairly robust.
But it is best when producers create relatively few activities and a
consumer requests their feed often.

An added beenfit of the polymorphic table is the ability to render different
partials in the view layer.

*Assume there is a `#recent_activities` method on `Person` which grabs a sorted
list of activities for that person.*

First, grab the collection in the controller:

    @activities = current_person.recent_activities

Then you can render polymorphic partials like so:

    @activities.each do |activity|
        render "#{activity.name}_#{activity.direction}_followed"
    end

You can read more about push vs. pull in this article from Yahoo Research:
research.yahoo.com/files/sigmod278-silberstein.pdf

Thoughtbot also has a blog post about using polymorphism to create an activity
feed:
http://robots.thoughtbot.com/using-polymorphism-to-make-a-better-activity-feed-in-rails
