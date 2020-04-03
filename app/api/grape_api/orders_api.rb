# frozen_string_literal: true

class GrapeApi
  class OrdersApi < Grape::API
    format :json

    namespace :orders do
      params do
        optional :cost, type: Integer
      end
      get do
        orders = if params[:cost].present?
                   Order.where('cost >= :cost', cost: params[:cost])
                 else
                   Order.all
        end
        present orders
      end

      route_param :user_id, type: Integer do
        get do
          Rails.logger.debug "user_par: #{params}"
          order = Order.where(user_id: params[:user_id])
          error!({ message: 'Order не найден' }, 404) unless order
          present order
        end
      end
    end
  end
  end
