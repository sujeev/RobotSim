class CreateRobots < ActiveRecord::Migration[7.1]
  def change
    create_table :robots do |t|
      t.integer :x_position
      t.integer :y_position
      t.integer :facing, default: 0

      t.timestamps
    end
  end
end
