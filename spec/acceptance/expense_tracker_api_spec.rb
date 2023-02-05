require 'rack/test'
require 'json'
require_relative '../../app/api'

# Nesting code in a module so we have access
# to all relevant classes
module ExpenseTracker
  RSpec.describe 'Expense Tracker API' do
    include Rack::Test::Methods

    def app
      ExpenseTracker::API.new
    end

    it 'records submitted expenses' do
      # Strings hash keys for compatibility
      coffee = {
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      }
    
      # post method comes from Rack::Test::Methods
      post '/expenses', JSON.generate(coffee)

      expect(last_response.status).to eq(200)
    end
  end 
end
