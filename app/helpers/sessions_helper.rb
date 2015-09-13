module SessionsHelper
	def sign_in(user)
    remember_token = User.new_remember_token #1) トークンを新規作成する。
    cookies.permanent[:remember_token] = remember_token #2) 暗号化されていないトークンをブラウザのcookiesに保存する。
    user.update_attribute(:remember_token, User.encrypt(remember_token)) #3) 暗号化したトークンをデータベースに保存する。
    self.current_user = user #4) 与えられたユーザーを現在のユーザーに設定する 
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
end
