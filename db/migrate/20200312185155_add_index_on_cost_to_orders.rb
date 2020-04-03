# frozen_string_literal: true

class AddIndexOnCostToOrders < ActiveRecord::Migration[6.0]
  def change
    add_index :orders, :cost
  end
end
