class CreateHouses < ActiveRecord::Migration[6.1]
  def change
    create_table :houses do |t|
      t.string :address, null: false, default: 'N/A'
      t.timestamps
    end
  end
end
