class User < ActiveRecord::Base

	before_save { self.email = email.downcase }
	validates :name,  presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },uniqueness: true #validates :uniquenessを使用しても、一意性は保証されません。


    has_secure_password
    validates :password, length: { minimum: 6 }

end
