class CreateEnrollments < ActiveRecord::Migration[5.1]
  def change
    create_table :enrollments do |t|
      t.integer :user_id
      t.integer :event_id
      t.string :rsvp

      t.timestamps
    end

    add_index :enrollments, [:user_id, :event_id]

  end
end
