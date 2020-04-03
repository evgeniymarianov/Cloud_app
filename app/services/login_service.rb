# frozen_string_literal: true

class LoginService
  attr_reader :login, :password, :session

  def initialize(login, password, session)
    @login = login
    @password = password
    @session = session
  end

  def message
    raise if password != '123'

    session[:login] = login
    session[:credits] ||= 1000

    "#{login}, вы вошли в #{Time.now}"
    Rails.logger.debug "cpu: #{session[:id]}"
    Rails.logger.debug "cpu: #{session[:credits]}"
  end
end
