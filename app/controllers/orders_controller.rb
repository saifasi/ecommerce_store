class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart, only: [:new, :create]

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def new
    redirect_to root_path, alert: 'Cart is empty.' if @cart.empty?
  end

  def create
    @order = current_user.orders.build(status: 'pending', total_price: 0)
    @cart.each do |pid, qty|
      prod = Product.find(pid)
      @order.order_items.build(
        product: prod,
        quantity: qty,
        purchase_price: prod.price
      )
      @order.total_price += prod.price * qty
    end
    tax_rate = current_user.province.slice(:gst_rate, :pst_rate, :hst_rate).values.sum / 100.0
    @order.total_price *= (1 + tax_rate)
    if @order.save
      session[:cart] = {}
      redirect_to @order, notice: 'Order placed successfully.'
    else
      render :new
    end
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def pay
    @order = current_user.orders.find(params[:id])
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    charge = Stripe::Charge.create(
      amount: (@order.total_price * 100).to_i,
      currency: 'cad',
      source: params[:stripeToken],
      description: "Order ##{@order.id}"
    )
    @order.update(status: 'paid', stripe_charge_id: charge.id)
    redirect_to @order, notice: 'Payment successful.'
  rescue Stripe::CardError => e
    redirect_to @order, alert: e.message
  end

  private
    def load_cart
      session[:cart] ||= {}
      @cart = session[:cart]
    end
end
