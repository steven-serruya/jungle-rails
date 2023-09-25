class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, if: :password_present?

  validates :first_name, presence: true
  validates :last_name, presence: true
  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def password_present?
    password.present?
  end

  def self.authenticate_with_credentials(email, password)
    user = User.where('LOWER(email) = ?', email.downcase.strip).first
    user && user.authenticate(password) ? user : nil
end


  

end