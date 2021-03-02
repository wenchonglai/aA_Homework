class CreateCats < ActiveRecord::Migration[5.2]
  def change
    create_table :cats do |t|
      t.date :birth_date, {null: false}
      t.string :color, {null: false}
      t.string :name, {null: false}
      t.string :sex, {limit: 1, null: false}
      t.string :url, {null: false}
      t.text :description, {default: ''}
      t.integer :user_id, {null: false}

      t.timestamps
    end

    add_index :cats, :name
    add_index :cats, :user_id
  end
end
