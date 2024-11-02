class ModifyIndexToRequestNumber < ActiveRecord::Migration[7.2]
  def change
    remove_index :estimates, :request_number
    add_index :estimates, :request_number, unique: false
  end
end
