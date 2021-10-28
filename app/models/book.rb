class Book < ApplicationRecord
  belongs_to :author
  has_many :loans

  def loan(user_id)
    user = User.find(user_id)
    return "Error: User has reached maximum loans" unless user.can_loan?
    return "Error: Book has no available hard copies" unless available_for_loan?

    loan = Loan.new(user: user, book: self)
    if loan.save
      'Book has been succesfully loaned'
    else
      'Error: Something went wrong'
    end
  end

  def return_book(user_id)
    loan = Loan.where(user_id: user_id, book_id: self.id, return_date: nil).last
    return "Error: There is no active loan for current user and book" unless loan
    loan.return_date = Date.current
    if loan.save
      'Book has been succesfully returned'
    else
      'Error: Something went wrong'
    end
  end

  private

    def available_for_loan?
      Loan.where(book: self, return_date: nil).count < self.number_of_hard_copies
    end
end
