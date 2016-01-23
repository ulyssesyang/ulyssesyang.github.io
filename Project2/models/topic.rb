
class Topic

	@@db = PG.connect({dbname: 'project2'})

	def initialize(attributes={})
    @id = attributes["id"]
    @name = attributes["name"]
    @description = attributes["description"]
    @user_id = attributes["user_id"]
  end

	def self.all
  	@@db.exec_params("SELECT * FROM topic")
  end

  def self.find_name(str)
  	@@db.exec_params(<<-SQL,[str])
  	SELECT (SELECT count(*) FROM disc WHERE disc.topic_id=topic.id) AS disc_count, topic.*, forum_user.username
		FROM topic
		join topic_user ON topic.id =  topic_user.topic_id
		join forum_user ON topic_user.user_id = forum_user.id
		WHERE topic.name ~ $1
		ORDER BY disc_count DESC
		SQL
  end

end