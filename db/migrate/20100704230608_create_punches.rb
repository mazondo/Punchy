class CreatePunches < ActiveRecord::Migration
  def self.up
    create_table :punches do |t|
      t.text :body
      t.integer :duration_in_minutes

      t.timestamps
    end
  end

  def self.down
    drop_table :punches
  end
end
