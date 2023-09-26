class Order < ApplicationRecord
  has_many :line_items

  monetize :total_cents, numericality: true

  validates :stripe_charge_id, presence: true

  after_create :deduct_product_quantity

  private

  def deduct_product_quantity
    line_items.each do |line_item|
      product = line_item.product
      product.update!(quantity: product.quantity - line_item.quantity)
    end
  end
end
