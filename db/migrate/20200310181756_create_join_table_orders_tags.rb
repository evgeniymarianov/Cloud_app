# frozen_string_literal: true

class CreateJoinTableOrdersTags < ActiveRecord::Migration[6.0]
  def change
    create_join_table :orders, :tags do |t|
      # t.index [:order_id, :tag_id]
      # t.index [:tag_id, :order_id]
    end
  end
end
