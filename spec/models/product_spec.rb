require 'rails_helper'


RSpec.describe Product, type: :model do
  describe 'Validations' do
    before :each do
      @category = Category.create(name: "Sample Category") # assuming you have a Category model with a name attribute
      @product = Product.new(name: "Sample Product", price_cents: 100, quantity: 5, category: @category)
    end

    it 'should save successfully with all fields set' do
      expect(@product.save).to be_truthy
    end
  
    it 'should not save without a name' do
      @product.name = nil
      @product.save
      expect(@product.errors.full_messages).to include("Name can't be blank")
    end

    it 'should not save without a price' do
      @product.price_cents = nil
      @product.save
      expect(@product.errors.full_messages).to include("Price can't be blank")
    end

    it 'should not save without a quantity' do
      @product.quantity = nil
      @product.save
      expect(@product.errors.full_messages).to include("Quantity can't be blank")
    end
  
    it 'should not save without a category' do
      @product.category = nil
      @product.save
      expect(@product.errors.full_messages).to include("Category can't be blank")
    end
  end
end
