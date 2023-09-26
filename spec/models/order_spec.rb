require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'After creation' do
    before :each do
      @category = Category.create!(name: "Test Category")
      @product1 = Product.create!(name: "Test Product 1", price: 100, quantity: 10, category: @category)
      @product2 = Product.create!(name: "Test Product 2", price: 200, quantity: 5, category: @category)
      @product3 = Product.create!(name: "Test Product 3", price: 150, quantity: 7, category: @category)
    end
    
    it 'deducts quantity from products based on their line item quantities' do
      @order = Order.new(stripe_charge_id: "test_charge_id")

      line_item1 = @order.line_items.build(product: @product1, quantity: 2)
      line_item1.item_price_cents = @product1.price_cents
      line_item1.total_price_cents = @product1.price_cents * line_item1.quantity

      line_item2 = @order.line_items.build(product: @product2, quantity: 3)
      line_item2.item_price_cents = @product2.price_cents
      line_item2.total_price_cents = @product2.price_cents * line_item2.quantity
      
      @order.total_cents = @order.line_items.sum { |item| item.total_price_cents }
      @order.save!

      @product1.reload
      @product2.reload

      expect(@product1.quantity).to eq(8)  # 10 - 2 = 8
      expect(@product2.quantity).to eq(2)  # 5 - 3 = 2
    end

    it 'does not deduct quantity from products that are not in the order' do
      @order = Order.new(stripe_charge_id: "test_charge_id")

      line_item1 = @order.line_items.build(product: @product1, quantity: 1)
      line_item1.item_price_cents = @product1.price_cents
      line_item1.total_price_cents = @product1.price_cents * line_item1.quantity

      line_item2 = @order.line_items.build(product: @product2, quantity: 1)
      line_item2.item_price_cents = @product2.price_cents
      line_item2.total_price_cents = @product2.price_cents * line_item2.quantity
      
      @order.total_cents = @order.line_items.sum { |item| item.total_price_cents }
      @order.save!

      @product3.reload

      expect(@product3.quantity).to eq(7)  # Remains unchanged
    end
  end
end
