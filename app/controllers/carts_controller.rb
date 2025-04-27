class CartsController < ApplicationController
  before_action :initialize_cart

  def show
    @items = @cart.map { |pid, qty| [Product.find(pid), qty] }
  end

  def add
    @cart[pid = params[:product_id].to_s] = (@cart[pid] || 0) + 1
    session[:cart] = @cart
    redirect_to cart_path, notice: 'Added to cart.'
  end

  def update
    @cart[params[:product_id].to_s] = params[:quantity].to_i
    session[:cart] = @cart
    redirect_to cart_path, notice: 'Cart updated.'
  end

  def remove
    @cart.delete(params[:product_id].to_s)
    session[:cart] = @cart
    redirect_to cart_path, notice: 'Removed from cart.'
  end

  private

  def initialize_cart
    session[:cart] ||= {}
    @cart = session[:cart]
  end
end
