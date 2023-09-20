class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.timestamps
      t.datetime :posted_at
      t.references :user
      t.string :title
      t.text :body
      t.string :slug
    end
  end
end
