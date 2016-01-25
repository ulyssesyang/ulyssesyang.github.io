module YuYangForum
	class User
		attr_reader :id
    attr_accessor :username, :email, :password_digest, :img_url

    def initialize(attributes={})
      @id = attributes["id"]
      @username = attributes["username"]
      @email = attributes["email"]
      @password_digest = attributes["password_digest"]
      @img_url = attributes["img_url"]
    end

    def self.find_by_id(id)
    	row = $db.exec_params("SELECT * FROM forum_user WHERE id = $1", [id]).first
    	new(row) if row
    end


	end
end