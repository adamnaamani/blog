class CreateSubscribers < ActiveRecord::Migration[7.0]
  def change
    create_table :subscribers do |t|
      t.timestamps
      t.string :email, index: { unique: true }
    end
  end
end
