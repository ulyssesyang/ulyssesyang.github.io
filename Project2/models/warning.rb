class Warningmsg

	def self.account_exist
		@account_exist=<<-str
			<div class="alert alert-danger">
    		<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
    		<strong>Danger!</strong> The username has already existed! Please choose another username!
  		</div>
			str
	end

	def self.email_exist
		@email_exist=<<-str
			<div class="alert alert-danger">
    		<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
    		<strong>Danger!</strong> The email has already existed! Please use other email!
  		</div>
			str
	end

end