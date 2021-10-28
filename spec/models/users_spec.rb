require 'rails_helper'

describe User do
  describe 'db columns' do
    it { should have_db_column(:id).of_type(:integer) }
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:is_librarian).of_type(:boolean) }
  end
end
