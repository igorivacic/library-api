class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :loans

  def can_loan?
    Loan.where(user: self, return_date: nil).count < 3
  end

  def igor

  end

  def loans
    Loan.where(user_id: id)
  end
end
