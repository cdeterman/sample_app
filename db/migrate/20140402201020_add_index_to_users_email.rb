class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
	  # rails method 'add_index' to add index on email column of the users table
	  add_index :users, :email, unique: true
  end
end
