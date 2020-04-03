# frozen_string_literal: true

class GrapeApi
  class UsersApi < Grape::API
    format :json

    namespace :users do
      route_param :id, type: Integer do
        get do
          user = User.find_by_id(params[:id])
          error!({ message: 'Пользователь не найден' }, 404) unless user
          present user
        end
      end

      desc 'Список пользователей',
           success: GrapeApi::Entities::User,
           is_array: true
      params do
        optional :age, type: Integer, desc: 'Age пользователя'
      end
      get do
        users = params[:age].present? ? User.where('age >= :age', age: params[:age]) : User.all
        present users, with: GrapeApi::Entities::User
      end

      desc 'Просмотр пользователя',
           success: GrapeApi::Entities::User,
           failure: [{ code: 404, message: 'Пользователь не найдена' }]
      params do
        optional :detail, type: Boolean, desc: 'Подробная информация о пользователях'
      end
      get do
        user = User.find_by_id(params[:id])
        error!({ message: 'Пользователь не найден' }, 404) unless user
        present user, with: GrapeApi::Entities::User, detail: params[:detail]
      end
    end
  end
  end
