# frozen_string_literal: true

class CheckService
  attr_reader :login, :password, :session, :credits, :cpu, :ram, :hdd_type, :hdd_capacity, :os, :total

  def initialize(params, _cpu, _ram, _hdd_type, _hdd_capacity, _os, session)
    @params = params
    @login = login
    @password = password
    @session = session
    @possibility = false
    @total = nil
    check_configs
    create_bill
  end


  def check_configs
    client = HTTPClient.new
    response1 = client.request(:get, 'http://possible_orders.srv.w55.ru/')
    possible_configs = JSON.parse(response1.body)['specs']

    result = false
    @params. each_pair do |_k, _v|
      @params[:cpu] = @params[:cpu].to_i
      @params[:ram] = @params[:ram].to_i
      @params[:hdd_capacity] = @params[:hdd_capacity].to_i
    end

    possible_configs.each do |h|
      next unless h['os'].include?(@params[:os]) && h['cpu'].include?(@params[:cpu]) && h['ram'].include?(@params[:ram]) && h['hdd_type'].include?(@params[:hdd_type])
        min = h['hdd_capacity'][@params[:hdd_type]]['from']
        max = h['hdd_capacity'][@params[:hdd_type]]['to']
        if (min <= @params[:hdd_capacity].to_i) && (@params[:hdd_capacity].to_i <= max)
          @possibility = true
          Rails.logger.debug "pos: #{@possibility}"
          order = Order.new(name: Time.now.to_s, status: 'created', options: @params, user_id: session[:id]).save
        break
        end
      end
    end
  end

  def create_bill
    if @possibility
      client = HTTPClient.new
      response2 = client.request(:get, 'http://service_http:5678/', cpu: @params[:cpu], ram: @params[:ram], hdd_type: @params[:hdd_type], hdd_capacity: @params[:hdd_capacity])
      @total = JSON.parse(response2.body)
    end
  end

public
  def message
    Rails.logger.debug "session[:credits]: #{session[:credits]}"

    Rails.logger.debug "@total: #{@total}"
    
    balance_after_transaction = session[:credits] - @total

    if @possibility && (balance_after_transaction > 0)
      obj = {
        answer: {
          result: true,
          total: total,
          balance: session[:credits],
          balance_after_transaction: balance_after_transaction
        },
        status: :ok
      }

    else
      obj = {
        answer: {
          result: false,
          error: 'incorrect VM configuration or insufficient funds are used'
        },
        status: :not_acceptable
      }
    end

    if session[:login].nil? | session[:credits].nil?
      obj = {
        answer: {
          result: false,
          error: 'the current session does not have a username or balance'
        },
        status: :unauthorized
      }
    end

    obj
  rescue Errno::ECONNREFUSED
    obj = {
      answer: {
        result: false,
        error: 'error accessing the external system'
      },
      status: :service_unavailable
    }
  end