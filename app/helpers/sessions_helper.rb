module SessionsHelper

  def sign_in(user)
    # 1) トークンを新規作成する。
    # User.new_remember_tokenはUserモデルに定義されている。
    remember_token = User.new_remember_token 

    # 2) 暗号化されていないトークンをブラウザのcookiesに保存する。
    cookies.permanent[:remember_token] = remember_token 

    # 3) 暗号化したトークンをデータベースに保存する。
    # update_attribute (カラム名,アップデートしたい内容)
    user.update_attribute(:remember_token, User.encrypt(remember_token)) 

    #4) 与えられたユーザーを現在のユーザーに設定する。def current_user=(user)を呼んでる？
    self.current_user = user 
  end

  def signed_in?
    !current_user.nil?
  end

  # current_user=(引数)はself.current_user =と同義。
  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  
  # フレンドリーフォワーディング
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end
end
