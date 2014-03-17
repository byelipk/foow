class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :subject, polymorphic: true
      t.string :name
      t.string :direction
      t.integer :person_id
      t.timestamps
    end
  end
end
