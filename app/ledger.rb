require_relative '../config/sequel'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  class Ledger
    def record(expense)
      unless valid_expense?(expense)
        message = 'Invalid expense'
        return RecordResult.new(false, nil, message)
      end

      DB[:expenses].insert(expense)
      id = DB[:expenses].max(:id)
      RecordResult.new(true, id, nil)
    end

    def expenses_on(date)
      DB[:expenses].where(date: date).all
    end

    private

    def valid_expense?(expense)
      has_date?(expense) && has_amount?(expense) && has_payee?(expense)
    end

    def has_date?(expense)
      expense.key?('date') && /\d{4}\-\d{2}-\d{2}/.match(expense['date'])
    end

    def has_amount?(expense)
      expense.key?('amount') && expense['amount'] > 0
    end

    def has_payee?(expense)
      expense.key?('payee') && expense['payee'].length > 0 
    end
  end
end