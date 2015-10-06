class User < ActiveRecord::Base

  # userが破棄された際に、has_manyしているmicropostsも破棄 
  has_many :microposts, dependent: :destroy
  # usersテーブルの主キーをfollower_idとマッピング
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  # コールバック　更新等をする前にcreate_remember_tokenを参照
	before_save { self.email = email.downcase }
  before_create :create_remember_token
	before_save { self.email = email.downcase }

	validates :name,  presence: true, 
                    length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # validates :uniquenessを使用しても、一意性は保証されません。
  validates :email, presence: true, uniqueness: true 

  # format: { with: VALID_EMAIL_REGEX },

  has_secure_password
  validates :password, length: { minimum: 6 }

  def User.new_remember_token
    # Rubyの標準ライブラリ　
    #A–Z、a–z、0–9、“-”、“_”のいずれかの文字 (64種類) からなる長さ16のランダムな文字列を返す。(そのためbase64)
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def feed
    Micropost.from_users_followed_by(self)
  end



private
  
  def create_remember_token
    # 記憶トークンを作成する。
    # selfがないと、remember_tokenというローカル変数ができてしまう。
    self.remember_token = User.encrypt(User.new_remember_token)
  end

end
