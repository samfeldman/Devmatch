class User < ActiveRecord::Base
	has_many :posts
	#has_many :links

end

class Post < ActiveRecord::Base
	belongs_to :user
end

class Follow < ActiveRecord::Base
	
end

#class Link <ActiveRecord::Base
#	belongs_to :user
#end