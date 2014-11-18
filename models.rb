class User < ActiveRecord::Base
	has_many :posts

	has_many :leaderships,
    	class_name: "Follower",
    	foreign_key: :leader_id

  	has_many :followerships,
    	class_name: "Follower",
    	foreign_key: :follower_id

	has_many :followers, 
		through: :leaderships, 
		source: :follower

	has_many :leaders, 
		through: :followerships, 
		source: :leader
end

class Post < ActiveRecord::Base
	belongs_to :user
end

class Follow < ActiveRecord::Base
	belongs_to :follower,
    	class_name: "User",
    	foreign_key: :follower_id
    belongs_to :leader,
    	class_name: "User",
    	foreign_key: :leader_id
end

#class Link <ActiveRecord::Base
#	belongs_to :user
#end