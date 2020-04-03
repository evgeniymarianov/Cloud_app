# frozen_string_literal: true

class OrdersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_order, only: %i[show edit update destroy]

  # GET /orders
  # GET /orders.json
  def index
    # @orders = Order.select('name', 'created_at', 'tags')
    @orders = Order.all
    # render json: {orders: @orders}
  end

  # GET /orders/1
  # GET /orders/1.json
  def show; end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit; end

  # POST /orders
  # POST /orders.json
  def create
    # byebug
    # @order = Order.new(order_params)
    @order = Order.new(order_params.to_h.merge({ user_id: session[:id] }))

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def approve
    render json: params
  end

  def calc
    render plain: 154
  end

  def first
    @order = Order.first
    render :show
  end

  def index
    @orders = Order.all
    puts "params: #{params.inspect}"
  end

  def check
    check_service = CheckService.new(params, params[:cpu], params[:ram], params[:hdd_type], params[:hdd_capacity], params[:os], session)
    render json: check_service.message[:answer], status: check_service.message[:status]
  end

    private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(:name, :status, :cost, :cpu, :ram, :hdd_type, :hdd_capacity, :os)
  end
  end
