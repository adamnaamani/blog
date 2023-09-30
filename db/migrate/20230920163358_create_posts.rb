class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.timestamps
      t.references :user
      t.integer :post_id
      t.string :title
      t.string :slug
      t.jsonb :meta
      t.datetime :post_date
      t.datetime :published_date
      t.integer :status, default: 0
    end
  end
end
