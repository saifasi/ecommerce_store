class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  belongs_to :province, optional: true
  has_many :orders, dependent: :destroy
  validates :name, presence: true
end