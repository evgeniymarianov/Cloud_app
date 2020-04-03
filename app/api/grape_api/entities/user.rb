# frozen_string_literal: true

class GrapeApi
  module Entities
    class User < Grape::Entity
      expose :id, documentation: { type: 'integer', desc: 'Идентификатор пользователя', required: true }
      expose :full_info, documentation: { type: 'string', desc: 'Полное имя пользователя', required: true }
      expose :age, if: ->(_object, options) { options[:detail] == true }

      def full_info
        "#{object.name} #{object.age}"
      end
    end
  end
  end
