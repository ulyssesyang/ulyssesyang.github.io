module YuYangForum
  class Comment
  	attr_reader :id
    attr_accessor :description, :create_time, :edit_time, :img_url, :user_id

  	def initialize(attributes={})
      @id = attributes["id"]
      @description = attributes["description"]
      @create_time = attributes["create_time"]
      @edit_time = attributes["edit_time"]
      @img_url = attributes["img_url"]
      @user_id = attributes["user_id"]
      @disc_id = attributes["disc_id"]
    end

    def self.find_by_disc_id(disc_id)
    	$db.exec_params(<<-SQL,[disc_id])
  			SELECT comment.*, forum_user.username, forum_user.img_url AS user_img, disc.name AS disc_name
				FROM comment
					join forum_user ON forum_user.id =  comment.user_id
					join disc ON comment.disc_id = disc.id
				WHERE disc.id = $1
	  	SQL
    end

    def self.find_by_comm_id(comm_id)
    	$db.exec_params(<<-SQL,[comm_id])
  			SELECT comment.*, forum_user.username, forum_user.img_url AS user_img, disc.name AS disc_name
				FROM comment
						join forum_user ON forum_user.id =  comment.user_id
						join disc ON comment.disc_id = disc.id
				WHERE comment.id = $1
  	  SQL
    end

    def self.create_comm(description, img_url, user_id, disc_id)
    	$db.exec_params(<<-SQL, [description, img_url, user_id, disc_id])
	  		INSERT INTO comment (description, img_url, user_id, disc_id)
	  		VALUES ($1, $2, $3, $4) RETURNING id
			SQL
    end

    def self.update_comm(description, img_url, comm_id)
    	$db.exec_params(<<-SQL, [description, img_url, comm_id])
	  		UPDATE comment SET description=$1, img_url=$2, edit_time=CURRENT_TIMESTAMP WHERE id=$3
			SQL
    end

    def self.del_comm_by_disc_id(disc_id)
    	$db.exec_params("DELETE FROM comment WHERE disc_id = $1",[disc_id])
    end

    def self.del_comm_by_comm_id(comm_id)
    	$db.exec_params("DELETE FROM comment WHERE id = $1",[comm_id])
    end

  end
end