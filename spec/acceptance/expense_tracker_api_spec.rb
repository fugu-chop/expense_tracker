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

    def post_expense(expense)
      # post method comes from Rack::Test::Methods
      post '/expenses', JSON.generate(expense)
      expect(last_response.status).to eq(200)
      
      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
      # merge the id into the JSON body so that we
      # can use whatever id the database creates
      expense.merge('id' => parsed['expense_id'])
    end

    it 'records submitted expenses' do
      # Strings hash keys for compatibility
      coffee = post_expense(
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      )
    end
  end 
end
