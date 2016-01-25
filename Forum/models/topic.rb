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

    def self.get_rate_by_name(name)
      $db.exec_params("SELECT * FROM topic WHERE name=$1",[name]).first['topic_rate'].to_i
    end

    def self.add_rate_by_name(name)
      $db.exec_params(<<-SQL, [name])
      UPDATE topic SET topic_rate=topic_rate+1 WHERE name=$1
      SQL
    end

    def self.del_rate_by_name(name)
      $db.exec_params(<<-SQL, [name])
      UPDATE topic SET topic_rate=topic_rate-1 WHERE name=$1
      SQL
    end

    def self.find_by_name(name)
    	$db.exec_params("SELECT * FROM topic WHERE LOWER(name)=LOWER($1)",[name])
    end

    def self.create_topic(name, description, img_url)
      $db.exec_params(<<-SQL, [name, description, img_url])
        INSERT INTO topic (name, description, img_url)
        VALUES ($1, $2, $3) RETURNING id
      SQL
    end

    def self.create_user_topic(user_id, topic_id)
      $db.exec_params(<<-SQL, [user_id, topic_id])
        INSERT INTO topic_user (user_id, topic_id)
        VALUES ($1, $2)
      SQL
    end

    def self.topic_name_order_by_disc_count(topic_name)
      $db.exec_params(<<-SQL, [topic_name])
      SELECT (SELECT count(*) FROM disc WHERE disc.topic_id=topic.id) AS disc_count, topic.*, topic_user.user_id, forum_user.username
      FROM topic
      join topic_user ON topic.id =  topic_user.topic_id
      join forum_user ON topic_user.user_id = forum_user.id
      WHERE topic.name = $1
      ORDER BY disc_count DESC
      SQL
    end

    def self.update_topic(new_name, description, img_url,topic_name)
      $db.exec_params(<<-SQL, [new_name, description, img_url,topic_name])
        UPDATE topic SET name=$1, description=$2, img_url=$3, edit_time=CURRENT_TIMESTAMP WHERE name=$4
      SQL
    end

    def self.del_topic(name)
      $db.exec_params("DELETE FROM topic WHERE name = $1",[name])
    end

  end
end