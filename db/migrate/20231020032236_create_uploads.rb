class CreateUploads < ActiveRecord::Migration[7.0]
  def change
    create_table :uploads do |t|
      t.timestamps
      t.references :user
      t.string :name
      t.string :category
    end
  end
end
