RSpec.configure do |c| 
	c.before(:suite) do
    # Run migration files
		Sequel.extension :migration
		Sequel::Migrator.run(DB, 'db/migrations')
    # Remove existing leftover test data
		DB[:expenses].truncate
	end
end
