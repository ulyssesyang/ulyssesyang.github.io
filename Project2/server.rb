require 'pg'
require 'pry'
require "sinatra/base"
require "bcrypt"

class Server < Sinatra::Base
	enable :sessions
	set :method_override, true

	@@db = PG.connect({dbname: 'project2'})

	def current_user
		@current_user ||= @@db.exec_params("SELECT * FROM forum_user WHERE id = $1", [session["user_id"]]).first
	end

	get "/welcome" do
		erb :welcome
	end

	get "/" do
		redirect "/welcome"
	end

	get "/welcome/" do
		redirect "/welcome"
	end

	post "/welcome/signup" do
		password_digest = BCrypt::Password.create(params["password"])
		get_user = @@db.exec_params("SELECT * FROM forum_user WHERE username=$1",[params["username"]])
		get_email = @@db.exec_params("SELECT * FROM forum_user WHERE email=$1",[params["email"]])
		if get_user.values.length>0
			@str="The username has already existed! Please choose another username!"
			erb :welcome
		elsif get_email.values.length>0
			@str="The email has already existed! Please use other email!"
			erb :welcome
		else
			new_user=@@db.exec_params(<<-SQL, [params["username"],params["email"],password_digest])
	  		INSERT INTO forum_user (username, email, password_digest)
	  		VALUES ($1, $2, $3) RETURNING id
			SQL
			session["user_id"]=new_user[0]["id"].to_i
			@str="Sign up successfully!"
			redirect "/forum"
		end
	end

	post "/welcome/login" do
		user_login=@@db.exec_params("SELECT * FROM forum_user WHERE username=$1",[params["username"]])
		if user_login.values.length>0
			temp=BCrypt::Password.new(user_login[0]['password_digest'])
			if temp==params["password"]
				session["user_id"]=user_login[0]["id"].to_i
				@str="Log in successfully!"
				redirect "/forum"
			else
				@str="Wrong password! Please double check your password!"
				erb :welcome
			end
		else 
			@str="The name doesn't exist! Please double check your username or sign up!"
			erb :welcome
		end
	end

	get "/profile" do
		if !current_user
			redirect "/welcome"
		else
    	id=current_user['id']
    	@user_login=@@db.exec_params("SELECT * FROM forum_user WHERE id = $1",[id])
    	erb :profile
		end
  end

	put "/profile" do
		if !current_user
			redirect "/welcome"
		else
			user_id=current_user['id']
			username=params["username"]
			email=params["email"]
	    fname=params["fname"]
	    lname=params["lname"]
			gender=params["gender"]
			phone=params["phone"]
	    img_url=params["img_url"]
	    @@db.exec_params(<<-SQL, [params["username"],params["email"],params["fname"],params["lname"],params["gender"],params["phone"],params["img_url"], user_id])
		  		UPDATE forum_user SET username=$1, email=$2, fname=$3, lname=$4, gender=$5, phone=$6, img_url=$7 WHERE id=$8
				SQL
			redirect "/forum"
		end
	end

	get "/logout" do
		session["user_id"]=nil
		redirect "/welcome"
	end

	get "/forum" do
		@topics=@@db.exec_params(<<-SQL)
		  		SELECT topic.*, forum_user.username
					FROM topic
							join topic_user ON topic.id =  topic_user.topic_id
							join forum_user ON topic_user.user_id = forum_user.id
				SQL
    @discs=@@db.exec_params("SELECT * FROM disc LIMIT 5")
		erb :forum
	end

	get "/forum/addtopic" do
		if !current_user
			redirect "/welcome"
		else
			erb :topic_add
		end
	end

	post "/forum/addtopic" do
		if !current_user
			redirect "/welcome"
		else
			get_topic = @@db.exec_params("SELECT * FROM topic WHERE name=$1",[params["name"]])
			if get_topic.values.length>0
				@str="The topic has already existed!"
				erb :topic_add
			else
				new_topic=@@db.exec_params(<<-SQL, [params["name"],params["description"],params["img_url"]])
		  		INSERT INTO topic (name, description, img_url)
		  		VALUES ($1, $2, $3) RETURNING id
				SQL
				@@db.exec_params(<<-SQL, [current_user["id"],new_topic[0]["id"]])
		  		INSERT INTO topic_user (user_id, topic_id)
		  		VALUES ($1, $2)
				SQL
				@str="You add this topic successfully!"
				redirect "/forum"
			end
		end
	end

	get "/forum/:name" do
		topic_name=params[:name]
		@topics=@@db.exec_params(<<-SQL, [topic_name])
		  		SELECT topic.*, topic_user.user_id, forum_user.username
					FROM topic
							join topic_user ON topic.id =  topic_user.topic_id
							join forum_user ON topic_user.user_id = forum_user.id
					WHERE name = $1
				SQL
    @discs=@@db.exec_params(<<-SQL,[topic_name])
    	SELECT * FROM disc WHERE topic_id IN (SELECT id FROM topic WHERE name = $1)
    	SQL
		erb :topic
	end

	get "/forum/:name/edittopic" do
		topic_name=params[:name]
		@topics=@@db.exec_params(<<-SQL, [topic_name])
		  		SELECT topic.*, topic_user.user_id, forum_user.username
					FROM topic
							join topic_user ON topic.id =  topic_user.topic_id
							join forum_user ON topic_user.user_id = forum_user.id
					WHERE name = $1
				SQL
		if !current_user
			@str="Please signup or login!"
			redirect "/welcome"
		elsif current_user['id']!=@topics.first['user_id']
			@str="You are not the creator of this topic!"
			redirect "/forum/#{params[:name]}"
		else
			erb :topic_edit
		end
	end

	put "/forum/:name/edittopic" do
		topic_name=params[:name]
    @@db.exec_params(<<-SQL, [params["new_name"],params["description"],params["img_url"],topic_name])
	  		UPDATE topic SET name=$1, description=$2, img_url=$3, edit_time=CURRENT_TIMESTAMP WHERE name=$4
			SQL
		redirect "/forum/#{params[:new_name]}"
	end

	delete "/forum/:name/delete" do
		@topic_name=params[:name]
		@topics=@@db.exec_params(<<-SQL, [topic_name])
		  		SELECT topic.*, topic_user.user_id, forum_user.username
					FROM topic
							join topic_user ON topic.id =  topic_user.topic_id
							join forum_user ON topic_user.user_id = forum_user.id
					WHERE name = $1
				SQL
		if !current_user
			@str="Please signup or login!"
			redirect "/welcome"
		elsif current_user['id']!=@topics.first['user_id']
			@str="You are not the creator of this topic!"
			redirect "/forum/#{params[:name]}"
		else
			@@db.exec_params("DELETE FROM comment WHERE disc_id = $1",[params[:name]])
			@@db.exec_params("DELETE FROM disc WHERE id = $1",[params[:name]])
			@@db.exec_params("DELETE FROM disc WHERE id = $1",[params[:name]])
			redirect "/forum"
		end
	end

	get "/forum/:name/adddisc" do
		@topic_name=params[:name]
		if !current_user
			redirect "/welcome"
		else
			erb :disc_add
		end
	end

	post "/forum/:name/adddisc" do
		@topic_name=params[:name]
		if !current_user
			redirect "/welcome"
		else
			get_disc = @@db.exec_params(<<-SQL,[params["disc_name"],params[:name]])
				SELECT * FROM disc WHERE name=$1 AND topic_id IN
				( SELECT id FROM topic WHERE name=$2)
			SQL
			if get_disc.values.length>0
				@str="The topic has already existed!"
				erb :disc_add
			else
				@topics=@@db.exec_params(<<-SQL, [params[:name]])
				  		SELECT * FROM topic WHERE name = $1
						SQL
				user_id=current_user['id'].to_i
				topic_id=@topics.first['id'].to_i
				new_disc=@@db.exec_params(<<-SQL, [params["disc_name"],params["description"],params["img_url"],user_id,topic_id])
		  		INSERT INTO disc (name, description, img_url, user_id, topic_id)
		  		VALUES ($1, $2, $3, $4, $5) RETURNING id
				SQL
				redirect "/forum/#{params[:name]}"
			end
		end
	end

	get "/forum/:name/:discid" do
		@topic_name=params[:name]
		disc_id=params[:discid].to_i
    @discs=@@db.exec_params(<<-SQL, [disc_id])
		  		SELECT disc.*, forum_user.username, topic.name AS topic_name
					FROM disc
							join forum_user ON forum_user.id =  disc.user_id
							join topic ON disc.topic_id = topic.id
					WHERE disc.id = $1
				SQL
    @comments=@@db.exec_params(<<-SQL,[disc_id])
    	SELECT * FROM comment WHERE disc_id = $1
    	SQL
		erb :disc
	end

	get "/forum/:name/:discid/editdisc" do
		@topic_name=params[:name]
		disc_id=params[:discid]
		@discs=@@db.exec_params(<<-SQL, [disc_id])
		  		SELECT disc.*, forum_user.username, topic.name AS topic_name
					FROM disc
							join forum_user ON forum_user.id =  disc.user_id
							join topic ON disc.topic_id = topic.id
					WHERE id = $1
				SQL
		if !current_user
			@str="Please signup or login!"
			redirect "/welcome"
		elsif current_user['id']!=@discs.first['user_id']
			@str="You are not the creator of this topic!"
			redirect "/forum/#{params[:name]}"
		else
			erb :disc_edit
		end
	end

	put "/forum/:name/:discid/editdisc" do
		@topic_name=params[:name]
		disc_id=params[:discid]
    @@db.exec_params(<<-SQL, [params["new_name"],params["description"],params["img_url"],disc_id])
	  		UPDATE disc SET name=$1, description=$2, img_url=$3, edit_time=CURRENT_TIMESTAMP WHERE id=$4
			SQL
		redirect "/forum/#{params[:name]}/#{params[:discid]}"
	end

	delete "/forum/:name/:discid/delete" do
		@topic_name=params[:name]
		disc_id=params[:discid]
		@discs=@@db.exec_params(<<-SQL, [disc_id])
		  		SELECT disc.*, forum_user.username, topic.name AS topic_name
					FROM disc
							join forum_user ON forum_user.id =  disc.user_id
							join topic ON disc.topic_id = topic.id
					WHERE id = $1
				SQL
		if !current_user
			@str="Please signup or login!"
			redirect "/welcome"
		elsif current_user['id']!=@discs.first['user_id']
			@str="You are not the creator of this topic!"
			redirect "/forum/#{params[:name]}"
		else
			@@db.exec_params("DELETE FROM comment WHERE disc_id = $1",[disc_id])
			@@db.exec_params("DELETE FROM disc WHERE id = $1",[disc_id])
			redirect "/forum/#{params[:name]}"
		end
	end

	get "/forum/:name/:discid/addcomm" do
		@topic_name=params[:name]
		disc_id=params[:discid].to_i
		if !current_user
			@str="Please signup or login!"
			redirect "/welcome"
		else
	    @discs=@@db.exec_params(<<-SQL, [disc_id])
			  		SELECT disc.*, forum_user.username, topic.name AS topic_name
						FROM disc
								join forum_user ON forum_user.id =  disc.user_id
								join topic ON disc.topic_id = topic.id
						WHERE disc.id = $1
					SQL
	    @comments=@@db.exec_params(<<-SQL,[disc_id])
	    	SELECT * FROM comment WHERE disc_id = $1
	    	SQL
			erb :comm_add
		end
	end

	post "/forum/:name/:discid/addcomm" do
		@topic_name=params[:name]
		@disc_id=params[:discid].to_i
		binding.pry
		if !current_user
			redirect "/welcome"
		else
			user_id=current_user['id'].to_i
			new_comm=@@db.exec_params(<<-SQL, [params["description"],params["img_url"],user_id,@disc_id])
	  		INSERT INTO comment (description, img_url, user_id, disc_id)
	  		VALUES ($1, $2, $3, $4) RETURNING id
			SQL
			binding.pry
			redirect "/forum/#{params[:name]}/#{params[:discid]}"
		end
	end

	get "/forum/:name/:discid/editcomm" do
		@topic_name=params[:name]
		disc_id=params[:discid]
		@comments=@@db.exec_params(<<-SQL, [disc_id])
		  		SELECT comment.*, forum_user.username, topic.name AS topic_name
					FROM comment
							join forum_user ON forum_user.id =  comment.user_id
							join disc ON comment.disc_id = disc.id
					WHERE id = $1
				SQL
		if !current_user
			@str="Please signup or login!"
			redirect "/welcome"
		elsif current_user['id']!=@comments.first['user_id']
			@str="You are not the creator of this topic!"
			redirect "/forum/#{params[:name]}"
		else
			erb :comm_edit
		end
	end

	put "/forum/:name/:discid/editcomm" do
		@topic_name=params[:name]
		disc_id=params[:discid]
    @@db.exec_params(<<-SQL, [params["description"],params["img_url"],disc_id])
	  		UPDATE comment SET description=$1, img_url=$2, edit_time=CURRENT_TIMESTAMP WHERE id=$3
			SQL
		redirect "/forum/#{params[:name]}/#{params[:discid]}"
	end

	delete "/forum/:name/:discid/:commid" do
		@topic_name=params[:name]
		disc_id=params[:discid]
		@comm_id=params[:commid]
		@discs=@@db.exec_params(<<-SQL, [disc_id])
		  		SELECT disc.*, forum_user.username, topic.name AS topic_name
					FROM disc
							join forum_user ON forum_user.id =  disc.user_id
							join topic ON disc.topic_id = topic.id
					WHERE id = $1
				SQL
		if !current_user
			redirect "/welcome"
		elsif current_user['id']!=@discs.first['user_id']
			@str="You are not the creator of this comment!"
			erb :disc
		else
			@@db.exec_params("DELETE FROM comment WHERE id = $1",[disc_id])
			redirect "/forum/#{params[:name]}/#{params[:discid]}"
		end
	end
	
end