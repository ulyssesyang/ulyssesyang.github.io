require 'pry'
require "sinatra/base"
require "bcrypt"
require "redcarpet"
require 'uri'

require_relative 'models/connect'
require_relative 'models/markdown'
require_relative 'models/warning'
require_relative 'models/topic'
require_relative 'models/user'
require_relative 'models/disc'
require_relative 'models/comment'

module YuYangForum
	class Server < Sinatra::Base

		enable :sessions
		set :method_override, true

		def current_user
			@current_user ||= User.find_by_id(session["user_id"]).first
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
			get_user = User.find(params["username"])
			get_email = User.find(params["email"])
			if get_user.values.length>0
				@str = Warningmsg.account_exist
			elsif get_email.values.length>0
				@str = Warningmsg.email_exist
			else
				new_user = User.create(params["username"],params["email"],password_digest)
				session["user_id"] = new_user[0]["id"].to_i
				@str = Warningmsg.success
			end
			erb :welcome
		end

		post "/welcome/login" do
			user_login = User.find(params["login_input"])
			if user_login.values.length>0
				temp=BCrypt::Password.new(user_login[0]['password_digest'])
				if temp==params["password"]
					session["user_id"]=user_login[0]["id"].to_i
					@str=Warningmsg.success
				else
					@str=Warningmsg.wrongpassword
				end
			else 
				@str=Warningmsg.account_notexist
			end
			erb :welcome
		end

		post "/welcome/search" do
			@make_search=Topic.search_topic(params["search"])
			if @make_search.values.length>0
				@str=Warningmsg.makelist(@make_search)
			else
				@str=Warningmsg.nosuchtopic
			end
			erb :welcome
		end

		get "/view" do
			if !current_user
				@str=Warningmsg.notlogin
				erb :welcome
			else
	    	id = current_user['id']
	    	@users = User.all_order_by_disc_count
	    	erb :view
			end
	  end

	  get "/view/:name" do
			if !current_user
				@str = Warningmsg.notlogin
				erb :welcome
			else
	    	id=current_user['id']
	    	@users = User.user_disc_count(params[:name])
	    	erb :view
			end
	  end

	  get "/profile" do
			if !current_user
				@str=Warningmsg.notlogin
				erb :welcome
			else
	    	id=current_user['id']
	    	@user_login = User.find_by_id(id)
	    	erb :profile
			end
	  end

		put "/profile" do
			if !current_user
				@str=Warningmsg.notlogin
				erb :welcome
			else
				user_id=current_user['id']
				username=params["username"]
				email=params["email"]
		    fname=params["fname"]
		    lname=params["lname"]
				gender=params["gender"]
				phone=params["phone"]
		    img_url=params["img_url"]
				User.update(username,email,fname,lname,gender,phone,img_url,user_id)
				redirect "/forum"
			end
		end

		get "/logout" do
			session["user_id"]=nil
			@str=Warningmsg.notlogin
			erb :welcome
		end

		get "/forum" do
			@topics=Topic.all_order_by_disc_count
			@discs=Disc.all_order_by_disc_rate
			erb :forum
		end

		get "/forum/:name/addrate" do
			@topic_name = URI.escape(params[:name])
			if !current_user
				@str=Warningmsg.notlogin
				erb :welcome
			else
				Topic.add_rate_by_name(params[:name])
				redirect "/forum/#{@topic_name}"
			end
		end

		get "/forum/:name/delrate" do
			@topic_name = URI.escape(params[:name])
			get_rate = Topic.get_rate_by_name(params["name"])
			if !current_user
				@str=Warningmsg.notlogin
				erb :welcome
			elsif get_rate>0
				Topic.del_rate_by_name(params[:name])
			end
			redirect "/forum/#{@topic_name}"
		end

		get "/forum/addtopic" do
			if !current_user
				@str = Warningmsg.notlogin
				erb :welcome
			else
				erb :topic_add
			end
		end

		post "/forum/addtopic" do
			if !current_user
				@str = Warningmsg.notlogin
				erb :welcome
			else
				get_topic = Topic.find_by_topic_name(params["name"])
				if get_topic.values.length>0
					@str = Warningmsg.already_exist
					erb :topic_add
				else
					new_topic = Topic.create_topic(params["name"],params["description"],params["img_url"])
					Topic.create_user_topic(current_user["id"],new_topic[0]["id"])
					redirect "/forum"
				end
			end
		end

		get "/forum/:name" do
			topic_name = params[:name]
			@topics = Topic.find_by_topic_name(topic_name)
			@discs = Disc.find_by_topic_name(topic_name)
			erb :topic
		end

		get "/forum/:name/edittopic" do
			@topic_name = URI.escape(params[:name])
			topic_name=params[:name]
			@topics = Topic.find_by_topic_name(topic_name)
			if !current_user
				@str=Warningmsg.notlogin
				erb :welcome
			elsif current_user['id']!=@topics.first['user_id']
				@str=Warningmsg.notcreator
				redirect "/forum/#{@topic_name}"
			else
				erb :topic_edit
			end
		end

		put "/forum/:name/edittopic" do
			@topic_name = URI.escape(params[:name])
			topic_name=params[:name]
			@topics = Topic.find_by_topic_name(topic_name)
			get_topic = Topic.find_by_topic_name(params["new_name"])
			@new_name = URI.escape(params["new_name"])
			if topic_name!=params["new_name"] && get_topic.values.length>0
				@str=Warningmsg.already_exist
				erb :topic_edit
			else
				Topic.update_topic(params["new_name"],params["description"],params["img_url"],topic_name)
				redirect "/forum/#{@new_name}"
			end
		end

		delete "/forum/:name/delete" do
			@topic_name = URI.escape(params[:name])
			topic_name = params[:name]
			@topics = Topic.find_by_topic_name(topic_name)
			if !current_user
				@str=Warningmsg.notlogin
				erb :welcome
			elsif current_user['id']!=@topics.first['user_id']
				@str=Warningmsg.notcreator
				redirect "/forum/#{@topic_name}"
			else
				
				Topic.del_topic(topic_name)
				redirect "/forum"
			end
		end

		get "/forum/:name/adddisc" do
			@topic_name=params[:name]
			if !current_user
				@str=Warningmsg.notlogin
				erb :welcome
			else
				erb :disc_add
			end
		end

		post "/forum/:name/adddisc" do
			@topic_name = URI.escape(params[:name])
			if !current_user
				@str      = Warningmsg.notlogin
				erb :welcome
			else
				get_disc  = Disc.find_by_disc_name_topic_name(params["disc_name"],params[:name])
				if get_disc.values.length>0
					@str    = Warningmsg.already_exist
					erb :disc_add
				else
					@topics = Topic.find_by_topic_name(params[:name])
					user_id = current_user['id'].to_i
					topic_id= @topics.first['id'].to_i
					new_disc= Disc.create_disc(params["disc_name"],params["description"],params["img_url"],user_id,topic_id)
					@str=Warningmsg.success
					redirect "/forum/#{@topic_name}"
				end
			end
		end

		get "/forum/:name/:discid" do
			@topic_name = URI.escape(params[:name])
			disc_id 		= params[:discid].to_i
			@discs  		= Disc.find_by_disc_id(disc_id)
	    @comments		= Comment.find_by_disc_id(disc_id)
			erb :disc
		end

		get "/forum/:name/:discid/addrate" do
			@topic_name = URI.escape(params[:name])
			if !current_user
				@str = Warningmsg.notlogin
				erb :welcome
			else
				Disc.add_rate(params[:discid])
				redirect "/forum/#{@topic_name}/#{params[:discid]}"
			end
		end

		get "/forum/:name/:discid/delrate" do
			@topic_name = URI.escape(params[:name])
			get_rate = Disc.get_rate(params[:discid])
			if !current_user
				@str=Warningmsg.notlogin
				erb :welcome
			elsif get_rate>0
				Disc.del_rate(params[:discid])
			end
			redirect "/forum/#{@topic_name}/#{params[:discid]}"
		end

		get "/forum/:name/:discid/editdisc" do
			@topic_name = URI.escape(params[:name])
			disc_id 		= params[:discid].to_i
			@discs      = Disc.find_by_disc_id(disc_id)
			if !current_user
				@str=Warningmsg.notlogin
				erb :welcome
			elsif current_user['id']!=@discs.first['user_id']
				@str=Warningmsg.notcreator
				redirect "/forum/#{@topic_name}"
			else
				erb :disc_edit
			end
		end

		put "/forum/:name/:discid/editdisc" do
			@topic_name = URI.escape(params[:name])
			disc_id 		= params[:discid]
			@discs 			= Disc.find_by_disc_id(disc_id)
			disc_name=@discs.first['name']
			get_disc 		= Disc.find_by_disc_name_topic_name(params["new_name"],params[:name])
			if disc_name!=params["new_name"] && get_disc.values.length>0
				@str      = Warningmsg.already_exist
				erb :disc_edit
			else
				Disc.update_disc(params["new_name"],params["description"],params["img_url"],disc_id)
				@str      = Warningmsg.success
				redirect "/forum/#{@topic_name}/#{params[:discid]}"
			end
		end

		delete "/forum/:name/:discid/delete" do
			@topic_name = URI.escape(params[:name])
			disc_id     = params[:discid].to_i
			@discs      = Disc.find_by_disc_id(disc_id)
			if !current_user
				@str      = Warningmsg.notlogin
				erb :welcome
			elsif current_user['id']!=@discs.first['user_id']
				@str 			= Warningmsg.notcreator
				redirect "/forum/#{@topic_name}"
			else
				Comment.del_comm_by_disc_id(disc_id)
				Disc.del_disc(disc_id)
				@str 			= Warningmsg.success
				redirect "/forum/#{@topic_name}"
			end
		end

		get "/forum/:name/:discid/addcomm" do
			@topic_name = URI.escape(params[:name])
			@disc_id    = params[:discid].to_i
			if !current_user
				@str      = Warningmsg.notlogin
				erb :welcome
			else
		    @discs    = Disc.find_by_disc_id(@disc_id)
	    	@comments = Comment.find_by_disc_id(@disc_id)
				erb :comm_add
			end
		end

		post "/forum/:name/:discid/addcomm" do
			@topic_name = URI.escape(params[:name])
			@disc_id    = params[:discid].to_i
			if !current_user
				@str      = Warningmsg.notlogin
				erb :welcome
			else
				user_id   = current_user['id'].to_i
				new_comm  = Comment.create_comm(params["description"],params["img_url"],user_id,@disc_id)
				@str=Warningmsg.success
				redirect "/forum/#{@topic_name}/#{params[:discid]}"
			end
		end

		get "/forum/:name/:discid/:commid/editcomm" do
			@topic_name = URI.escape(params[:name])
			@disc_id    = params[:discid].to_i
			@comm_id    = params[:commid].to_i
			@comments   = Comment.find_by_comm_id(@comm_id)
			if !current_user
				@str      = Warningmsg.notlogin
				erb :welcome
			elsif current_user['id']!=@comments.first['user_id']
				@str      = Warningmsg.notcreator
				redirect "/forum/#{@topic_name}/#{params[:discid]}"
			else
				erb :comm_edit
			end
		end

		put "/forum/:name/:discid/:commid/editcomm" do
			@topic_name = URI.escape(params[:name])
			@disc_id    = params[:discid].to_i
			@comm_id    = params[:commid].to_i
			@comments   = Comment.find_by_comm_id(@comm_id)
			Comment.update_comm(params["description"],params["img_url"],@comm_id)
			@str  			= Warningmsg.success
			redirect "/forum/#{@topic_name}/#{params[:discid]}"
		end

		delete "/forum/:name/:discid/:commid/delete" do
			@topic_name = URI.escape(params[:name])
			@disc_id    = params[:discid].to_i
			@comm_id    = params[:commid].to_i
			@comments   = Comment.find_by_comm_id(@comm_id)
			if !current_user
				@str      = Warningmsg.notlogin
				erb :welcome
			elsif current_user['id'] != @comments.first['user_id']
				@str      = Warningmsg.notcreator
				redirect "/forum/#{@topic_name}/#{params[:discid]}"
			else
				Comment.del_comm_by_comm_id(@comm_id)
				@str      = Warningmsg.success
				redirect "/forum/#{@topic_name}/#{params[:discid]}"
			end
		end

	end
end