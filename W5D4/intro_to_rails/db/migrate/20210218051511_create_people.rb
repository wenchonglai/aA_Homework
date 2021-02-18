class CreatePeople < ActiveRecord::Migration[6.1]
  def change
    create_table :people do |t|
      t.string :name, {null: false, default: 'N/A'}
      t.integer :house_id, {null: false}
      t.timestamps
    end
  end
end
