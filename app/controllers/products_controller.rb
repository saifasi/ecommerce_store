class ProductsController < ApplicationController
  before_action :set_categories
  add_breadcrumb 'Home', :root_path

  def index
    @products = Product.all
    @products = @products.joins(:categories).where(categories: { id: params[:category_id] }) if params[:category_id]
    if params[:filter].in?(%w[sale new updated])
      @products = case params[:filter]
                  when 'sale'    then @products.where(on_sale: true)
                  when 'new'     then @products.where('created_at >= ?', 30.days.ago)
                  when 'updated' then @products.where('updated_at >= ?', 30.days.ago)
                  end
    end
    @products = @products.page(params[:page]).per(12)
  end

  def show
    @product = Product.find(params[:id])
    add_breadcrumb @product.name, product_path(@product)
  end

  def search
    @q = params[:q].to_s.strip
    @products = Product.where('name ILIKE ? OR description ILIKE ?', "%#{@q}%", "%#{@q}%")
    if params[:category_id].present?
      @products = @products.joins(:categories).where(categories: { id: params[:category_id] })
    end
    @products = @products.page(params[:page]).per(12)
    render :index
  end

  private
    def set_categories
      @categories = Category.all
    end
end
