class CreateNows < ActiveRecord::Migration[7.1]
  def change
    create_table :nows do |t|
      t.timestamps
      t.references :user
      t.integer :status, default: 0
    end
  end
end
