class Micropost < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('created_at DESC') }#新しい順にソートする。
	#DESCはdescendingで新しいものから古いものへ
	validates :user_id, presence: true
end
