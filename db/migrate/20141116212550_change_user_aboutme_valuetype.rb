class ChangeUserAboutmeValuetype < ActiveRecord::Migration
  def change
  	change_column :users, :aboutme, :text
  end
end
