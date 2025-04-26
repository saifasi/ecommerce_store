class Product < ApplicationRecord
  has_one_attached :image
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :order_items
  validates :name, :description, :price, :inventory_count, presence: true
end