configure :development do
	set :database, 'sqlite3:///dev.db'
	set :show_exception, true
end

configure :production do
	db = URI.parse(ENV['DATABASE_URL'] || 'postgresql:///localhost/my_db')

	ActiveRecord::Base.establish_connection(
		:adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
		:host => db.host,
		:username => db.user,
		:password => db.password,
		:database => db.path[1..-1],
		:encoding => 'utf8'
	)
end