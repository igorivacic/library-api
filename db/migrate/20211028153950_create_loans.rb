class CreateLoans < ActiveRecord::Migration[5.2]
  def change
    create_table :loans do |t|
      t.references :user, index: true
      t.references :book, index: true
      t.timestamps
    end
  end
end
