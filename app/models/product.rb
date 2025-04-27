class Product < ApplicationRecord
  has_one_attached :image
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :order_items

  validates :name, :description, :price, :inventory_count, presence: true

  scope :on_sale,   -> { where(on_sale: true) }
  scope :recent,    -> { where('created_at >= ?', 30.days.ago) }
  scope :recently_updated, -> { where('updated_at >= ?', 30.days.ago) }
end