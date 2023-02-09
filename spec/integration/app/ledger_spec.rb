require_relative '../../../app/ledger'
require_relative '../../../config/sequel'
require_relative '../../support/db'

module ExpenseTracker 
  RSpec.describe Ledger, :aggregate_failures do
    let(:ledger) { Ledger.new } 
    let(:expense) do
      {
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      }
    end

    describe '#record' do
      context 'with a valid expense' do
        # :aggregate_failures allows the spec to continue
        # running despite failing on the first expectation
        it 'successfully saves the expense in the DB' do
          result = ledger.record(expense)

          # Generally not good practice to have multiple
          # expectations in a single unit spec, but since
          # we're touching the database, such specs are
          # going to be slower for setup and teardown
          expect(result).to be_success
          expect(DB[:expenses].all).to match [a_hash_including(
            id: result.expense_id,
            payee: 'Starbucks',
            amount: 5.75,
            date: Date.iso8601('2017-06-10')
          )]
        end 
      end
    end
  end
end
