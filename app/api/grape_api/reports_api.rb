# frozen_string_literal: true

class GrapeApi
  class ReportsApi < Grape::API
    format :json

    namespace :reports do
      params do
        optional :cost, type: Integer
      end
      get do
        present Order.all
      end

      route_param :user_id, type: Integer do
        get do
          orders = Order.where(user_id: params[:user_id])
          user = params[:user_id]
          error!({ message: 'Order не найден' }, 404) unless orders
          vms = []
          orders.each { |k| vms << k[:options] }
          vms.each { |x|  x.merge!({ 'id' => vms.index(x) }) }
          require_to = { 'data' => vms }
          CreateReportWorker.perform_async(user, require_to)
          report = Report.find_by_user_id(user)
          present report.text
        end
      end
    end
  end
  end
