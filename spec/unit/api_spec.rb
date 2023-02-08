require_relative '../../app/api.rb'
require 'rack/test'

module ExpenseTracker
  RSpec.describe API do
    # Rack::Test allows us to simulate and route
    # HTTP requests to and from our app
    include Rack::Test::Methods

    def app
      API.new(ledger: ledger)
    end

    let(:ledger) { instance_double('ExpenseTracker::Ledger') }
    let(:expense) { { 'some' => 'data' } }
    let(:parsed) { JSON.parse(last_response.body) }

    describe 'POST /expenses' do
      context 'when the expense is successfully recorded' do
        before do
            allow(ledger).to receive(:record)
              .with(expense)
              .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the expense id' do
          # We don't move this into the before block
          # as we typically keep act and assert in
          # the test itself
          post '/expenses', JSON.generate(expense)
          
          expect(parsed).to include('expense_id' => 417)
        end
        
        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)

          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
        end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)

          expect(parsed).to include('error' => 'Expense incomplete')
        end
        
        it 'responds with a 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)

          expect(last_response.status).to eq(422)
        end
      end
    end

    describe 'GET /expenses/:date' do
      context 'when expenses exist on the given date' do
        it 'returns the expense records as JSON'
        it 'responds with a 200 (OK)'
      end

      context 'when there are no expenses on the given date' do
        it 'returns an empty array as JSON'
        it 'responds with a 200 (OK)'
      end
    end
  end
end
