class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.integer :city_id
      t.integer :price

      t.timestamps null: false
    end
    add_index :restaurants, :city_id
  end
end
