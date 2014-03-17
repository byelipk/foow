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

This design, when implemented on a PostgreSQL database is fairly robust. This
type of push model is best when producers create relatively few activities and a
consumer requests their feed often.

You can read more about push vs. pull in this article from Yahoo Research:
research.yahoo.com/files/sigmod278-silberstein.pdf
