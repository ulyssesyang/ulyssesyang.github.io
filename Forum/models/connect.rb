require "pg"

if ENV['DATABASE_URL']
	$db = PG.connect(ENV['DATABASE_URL'])
else
	$db = PG.connect({dbname: 'project2'})
end