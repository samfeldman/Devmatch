class CreateLinksTable < ActiveRecord::Migration
  def change
  	create_table :links do |t|
  		t.integer :user_id
  		t.string :link1
  		t.string :link3
  		t.string :link3
  		t.string :link4
  	end
  end
end
