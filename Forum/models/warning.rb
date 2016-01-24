
class Warningmsg

	def self.account_exist
		<<-str
		<div class="alert alert-warning">
  		<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
  		<strong>Warning!</strong> The username has already existed! Please choose another username!
		</div>
		str
	end

	def self.account_notexist
		<<-str
		<div class="alert alert-warning">
  		<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
  		<strong>Warning!</strong> The account doesn't exist! Please double check!
		</div>
		str
	end

	def self.email_exist
		<<-str
		<div class="alert alert-warning">
  		<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
  		<strong>Warning!</strong> The email has already existed! Please use other email!
		</div>
		str
	end

	def self.wrongpassword
		<<-str
		<div class="alert alert-warning">
  		<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
  		<strong>Warning!</strong> Wrong password! Please double check your password!
		</div>
		str
	end

	def self.success
		<<-str
		<div class="alert alert-success">
  		<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
  		<strong>Success!</strong>
		</div>
		str
	end

	def self.notlogin
		<<-str
		<div class="alert alert-warning">
  		<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
  		<strong>Warning!</strong> Please loging or signup!
		</div>
		str
	end

	def self.already_exist
		<<-str
		<div class="alert alert-warning">
  		<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
  		<strong>Warning!</strong> Already created! Please try again!
		</div>
		str
	end

	def self.notcreator
		<<-str
		<div class="alert alert-warning">
  		<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
  		<strong>Warning!</strong> You are not the creator!"
		</div>
		str
	end

	def self.nosuchtopic
		<<-str
		<div class="alert alert-warning">
  		<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
  		<strong>Warning!</strong> There are no such topics! You can create <a href="/forum/addtopic">here</a>
		</div>
		str
	end

	def self.makelist(arry)
		makelist=''
		arry.each do |el|
			str=<<-str
					<button type="button" class="btn btn-default" data-toggle="collapse" data-target="##{el['id']}">
						#{el['name']}
					</button>
					<div id="#{el['id']}" class="collapse">
						<a href="/forum/#{el['name']}"><img src="#{el['img_url']}" class="img-thumbnail" width="155" height="155"></a>
						<h5>
						Discussions: <span class="badge"> #{el['disc_count']}</span> 
						Rates: <span class="badge"> #{el['topic_rate']}</span>
						Created by:<a href="/view/#{el['username']}"> #{el['username']}</a>
						</h5>
					</div>
					str
			makelist+=str
		end
		return makelist
	end

end