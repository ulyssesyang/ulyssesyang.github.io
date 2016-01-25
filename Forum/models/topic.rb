module YuYangForum
  class Topic

    attr_reader :id
    attr_accessor :name, :description, :create_time, :edit_time, :topic_rate, :img_url, :user_id

  	def initialize(attributes={})
      @id = attributes["id"]
      @name = attributes["name"]
      @description = attributes["description"]
      @create_time = attributes["create_time"]
      @edit_time = attributes["edit_time"]
      @topic_rate = attributes["topic_rate"]
      @img_url = attributes["img_url"]
      @user_id = attributes["user_id"]
    end

  	def self.all_order_by_disc_count
    	$db.exec_params(<<-SQL)
        SELECT (SELECT count(*) FROM disc WHERE disc.topic_id=topic.id) AS disc_count, topic.*, forum_user.username
        FROM topic
        join topic_user ON topic.id =  topic_user.topic_id
        join forum_user ON topic_user.user_id = forum_user.id
        ORDER BY disc_count DESC
      SQL
    end

    def self.add_rate_by_name(name)
      $db.exec_params(<<-SQL, [name])
      UPDATE topic SET topic_rate=topic_rate+1 WHERE name=$1
      SQL
    end

    def self.find_by_name(name)
    	
    end

  end
end