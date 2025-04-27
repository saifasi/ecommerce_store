class ProductsController < ApplicationController
  before_action :set_categories
  add_breadcrumb 'Home', :root_path

  def index
    @products = Product.all

    # Filter-by-category (Step 2.2)
    if params[:category_id].present?
      @products = @products.joins(:categories).where(categories: { id: params[:category_id] })
      add_breadcrumb Category.find(params[:category_id]).name, category_path(params[:category_id])
    end

    # Filter options (Step 2.4)
    case params[:filter]
    when 'sale'    then @products = @products.on_sale
    when 'new'     then @products = @products.recent
    when 'updated' then @products = @products.recently_updated
    end

    # Pagination
    @products = @products.page(params[:page])

    render :index
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
    @products = @products.page(params[:page])
    render :index
  end

  private

  def set_categories
    @categories = Category.all
  end
end

