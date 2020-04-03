# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :name
      t.integer :status
      t.integer :cost

      t.timestamps
    end
  end
end
