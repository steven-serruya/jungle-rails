require 'rails_helper'

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do

    # It must be created with a password and password_confirmation fields
    it 'is valid with matching password and password_confirmation' do
      user = User.new(password: 'password123', password_confirmation: 'password123', email: 'test@test.com', first_name: 'John', last_name: 'Doe')
      expect(user).to be_valid
    end

    # These need to match so you should have an example for where they are not the same
    it 'is not valid when password and password_confirmation do not match' do
      user = User.new(password: 'password123', password_confirmation: 'password124', email: 'test@test.com', first_name: 'John', last_name: 'Doe')
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    # These are required when creating the model so you should also have an example for this
    it 'is not valid without a password and password_confirmation' do
      user = User.new(email: 'test@test.com', first_name: 'John', last_name: 'Doe')
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Password can't be blank")
    end

# Emails must be unique (not case sensitive; for example, TEST@TEST.com should not be allowed if test@test.COM is in the database)
it 'requires unique, case insensitive emails' do
  user1 = User.create!(password: 'password123', password_confirmation: 'password123', email: 'test@test.com', first_name: 'John', last_name: 'Doe')
  user2 = User.new(password: 'password123', password_confirmation: 'password123', email: 'TEST@TEST.com', first_name: 'Jane', last_name: 'Doe')
  user2.valid?
  expect(user2.errors.full_messages).to include("Email has already been taken")
end


    # Email, first name, and last name should also be required
    it 'requires an email, first name, and last name' do
      user = User.new(password: 'password123', password_confirmation: 'password123')
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Email can't be blank", "First name can't be blank", "Last name can't be blank")
    end

  end
end
