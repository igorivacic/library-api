class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :number_of_hard_copies
      t.references :author, index: true
      t.timestamps
    end
  end
end