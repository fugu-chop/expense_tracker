require_relative '../../app/api.rb'
require 'rack/test'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)
  
  RSpec.describe API do
    # Rack::Test allows us to simulate and route
    # HTTP requests to and from our app
    include Rack::Test::Methods

    def app
      API.new(ledger: ledger)
    end

    let(:ledger) { instance_double('ExpenseTracker::Ledger') }

    describe 'POST /expenses' do
      context 'when the expense is successfully recorded' do
          let(:expense) = { 'some' => 'data' }

          before do
            allow(ledger).to receive(:record)
              .with(expense)
              .and_return(RecordResult.new(true, 417, nil))
          end

        it 'returns the expense id' do
          # We don't move this into the before block
          # as we want to be flexible - we wouldn't
          # be able to handle XML related tests
          # as those require different header values
          post '/expenses', JSON.generate(expense)
          parsed = JSON.parse(last_response.body)
          
          expect(parsed).to include('expense_id' => 417)
        end
        
        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)

          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        it 'returns an error message'
        it 'responds with a 422 (Unprocessable entity)'
      end
    end
  end
end
