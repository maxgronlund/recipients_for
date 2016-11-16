class SpecMigration < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string :name
      t.string :email
    end

    create_table :cars, :force => true do |t|
      t.string :brand
      t.string :model
    end
  end

  def self.down
    drop_table :users
    drop_table :cars
  end
end