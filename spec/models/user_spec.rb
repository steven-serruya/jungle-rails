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

  # Test section for password length requirements
describe 'Password length validations' do

  # Test to ensure that passwords shorter than 8 characters are not valid
  it 'is not valid with a password shorter than 8 characters' do
    user = User.new(email: 'test@test.com', password: 'short', password_confirmation: 'short', first_name: 'John', last_name: 'Doe')
    expect(user).to_not be_valid
    expect(user.errors.full_messages).to include("Password is too short (minimum is 8 characters)")
  end

  # Test to confirm that passwords of 8 characters or more are valid
  it 'is valid with a password of 8 characters or more' do
    user = User.new(email: 'test@test.com', password: 'longpassword', password_confirmation: 'longpassword', first_name: 'John', last_name: 'Doe')
    expect(user).to be_valid
  end
end

# Test section for the custom authentication method
describe '.authenticate_with_credentials' do
  
  # Setup a sample user for authentication tests
  before do
    @user = User.create(email: 'test@test.com', password: 'password123', password_confirmation: 'password123', first_name: 'John', last_name: 'Doe')
  end

  # Test for successful authentication with correct credentials
  it 'authenticates valid credentials' do
    expect(User.authenticate_with_credentials('test@test.com', 'password123')).to eq(@user)
  end

  # Test for unsuccessful authentication with incorrect password
  it 'does not authenticate invalid credentials' do
    expect(User.authenticate_with_credentials('test@test.com', 'wrongpassword')).to be_nil
  end

  # Test for successful authentication even if email has leading/trailing whitespaces
  it 'authenticates with leading or trailing whitespaces in email' do
    expect(User.authenticate_with_credentials('  test@test.com  ', 'password123')).to eq(@user)
  end

  # Test for successful authentication with email in mixed case
  it 'authenticates with mixed case email' do
    expect(User.authenticate_with_credentials('TeSt@tEst.com', 'password123')).to eq(@user)
  end

  # Redundant test (as the above already covers this scenario), but keeping it for completeness
  it 'authenticates email with leading and trailing spaces' do
    authenticated_user = User.authenticate_with_credentials('  test@test.com  ', 'password123')
    expect(authenticated_user).to eq(@user)
  end

  # Another test for successful authentication with email in different cases
  it 'authenticates email with different case' do
    authenticated_user = User.authenticate_with_credentials('TeSt@tEst.COM', 'password123')
    expect(authenticated_user).to eq(@user)
  end
end

end
