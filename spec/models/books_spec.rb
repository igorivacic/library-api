require 'rails_helper'

describe Book do
  describe 'db columns' do
    it { should have_db_column(:id).of_type(:integer) }
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:number_of_hard_copies).of_type(:integer) }
    it { should have_db_column(:author_id).of_type(:integer) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end
end
