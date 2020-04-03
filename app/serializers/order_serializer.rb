# frozen_string_literal: true

class OrderSerializer < ActiveModel::Serializer
  attributes :id, :full_info

  def full_info
    "#{object.name} #{object.status} #{object.cost}"
  end
end
