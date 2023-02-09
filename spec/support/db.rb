RSpec.configure do |c|
  c.around(:example, :db) do |example| 
    DB.transaction(rollback: :always) { example.run }
  end

	c.before(:suite) do
    # Run migration files
		Sequel.extension :migration
		Sequel::Migrator.run(DB, 'db/migrations')
    # Remove existing leftover test data
		DB[:expenses].truncate
	end
end
