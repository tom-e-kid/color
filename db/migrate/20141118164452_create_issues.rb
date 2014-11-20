class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :issues, [:user_id, :created_at]
  end
end
