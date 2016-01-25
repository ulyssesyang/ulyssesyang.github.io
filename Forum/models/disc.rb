
module YuYangForum
  class Disc

  	attr_reader :id
    attr_accessor :name, :description, :create_time, :edit_time, :disc_rate, :img_url, :user_id

  	def initialize(attributes={})
      @id = attributes["id"]
      @name = attributes["name"]
      @description = attributes["description"]
      @create_time = attributes["create_time"]
      @edit_time = attributes["edit_time"]
      @disc_rate = attributes["disc_rate"]
      @img_url = attributes["img_url"]
      @user_id = attributes["user_id"]
      @topic_id = attributes["topic_id"]
    end

    def self.all_order_by_disc_rate
    	$db.exec_params(<<-SQL)
	  		SELECT (SELECT count(*) FROM comment WHERE comment.disc_id=disc.id) AS comm_count, disc.*, forum_user.username, topic.name AS topic_name
				FROM disc
						join forum_user ON forum_user.id =  disc.user_id
						join topic ON disc.topic_id = topic.id
				ORDER BY disc_rate DESC
			SQL
    end

  end
end