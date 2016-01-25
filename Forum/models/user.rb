
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
    	$db.exec_params("SELECT * FROM forum_user WHERE id = $1", [id])
    end

    def self.find(input)
    	$db.exec_params("SELECT * FROM forum_user WHERE username=$1 OR email = $1", [input])
    end

    def self.create(username,email,password_digest)
    	$db.exec_params(<<-SQL, [username,email,password_digest])
	  		INSERT INTO forum_user (username, email, password_digest)
	  		VALUES ($1, $2, $3) RETURNING id
			SQL
    end

    def self.update(username,email,fname,lname,gender,phone,img_url,user_id)
    	$db.exec_params(<<-SQL, [username,email,fname,lname,gender,phone,img_url,user_id])
	  		UPDATE forum_user SET username=$1, email=$2, fname=$3, lname=$4, gender=$5, phone=$6, img_url=$7 WHERE id=$8
			SQL
    end

    def self.all_order_by_disc_count
    	$db.exec_params(<<-SQL)
    		SELECT (SELECT count(*) FROM disc WHERE disc.user_id=forum_user.id) AS disc_count, forum_user.*
				FROM forum_user
				ORDER BY disc_count DESC
    	SQL
    end

    def self.user_disc_count(input)
    	$db.exec_params(<<-SQL,[input])
    		SELECT (SELECT count(*) FROM disc WHERE disc.user_id=forum_user.id) AS disc_count, forum_user.*
				FROM forum_user
				WHERE forum_user.username=$1
				ORDER BY disc_count DESC
    	SQL
    end

	end
end