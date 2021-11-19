class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :text
      t.timestamps
      t.references :user, null: false, foreign_key: {on_delete: :cascade}
    end
  end
end
