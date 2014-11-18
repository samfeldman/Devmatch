class User < ActiveRecord::Base

	has_many :posts

	has_many :followeeships,
    	class_name: "Follow",
    	foreign_key: :followee_id

  	has_many :followerships,
    	class_name: "Follow",
    	foreign_key: :follower_id

	has_many :followers, 
		through: :followeeships, 
		source: :follower

	has_many :followees, 
		through: :followerships, 
		source: :followee

end

class Post < ActiveRecord::Base
	belongs_to :user
end

class Follow < ActiveRecord::Base
	belongs_to :follower,
    	class_name: "User",
    	foreign_key: :follower_id
    belongs_to :followee,
    	class_name: "User",
    	foreign_key: :followee_id
end

#class Link <ActiveRecord::Base
#	belongs_to :user
#end