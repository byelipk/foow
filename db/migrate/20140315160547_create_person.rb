class CreatePerson < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.integer :user_id
      t.timestamps
    end
  end
end
