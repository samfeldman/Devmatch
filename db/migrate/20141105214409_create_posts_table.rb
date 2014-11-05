class CreatePostsTable < ActiveRecord::Migration
  def change
  	create_table :posts do |t|
  		t.integer :user_id
  		t.datetime :posttime
  		t.string :text
  	end
  end
end
