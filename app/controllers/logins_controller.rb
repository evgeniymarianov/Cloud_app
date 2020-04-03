# frozen_string_literal: true

class LoginsController < ApplicationController
  rescue_from RuntimeError do
    redirect_to :login, notice: 'Неверный пароль'
  end
  def show; end

  def create
    user = User.create!(name: params[:login])
    session[:id] = user.id
    login_service = LoginService.new(params[:login], params[:password], session)
    redirect_to :login, notice: login_service.message
  end

  def destroy
    session.delete(:login)
    redirect_to :login, notice: 'Вы вышли'
  end
end
