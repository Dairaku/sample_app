class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  #ヘルパーメソッドはデフォルトではviewでしか使用可能になってないので、コントローラーで使えることを明示する。
  include SessionsHelper 
  protect_from_forgery with: :exception

end
