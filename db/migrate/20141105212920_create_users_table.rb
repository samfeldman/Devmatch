class CreateUsersTable < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string :fname
  		t.string :lname
  		t.string :email
  		t.string :password
  		t.string :location
  		t.string :company
  		t.string :sex
  		t.datetime :birthday
  		t.string :aboutme
  	end
  end
end
