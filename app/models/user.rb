class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :loans

  def can_loan?
    Loan.where(user: self, return_date: nil).count < 3
  end

  def loans
    Loan.where(user_id: self.id)
  end
end
