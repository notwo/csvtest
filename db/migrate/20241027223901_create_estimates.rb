class CreateEstimates < ActiveRecord::Migration[7.2]
  def change
    create_table :estimates do |t|
      t.string :request_number

      t.timestamps
    end
    add_index :estimates, :request_number, unique: true
  end
end
