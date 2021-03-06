class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include SessionsHelper #ヘルパーメソッドはデフォルトではviewでしか使用可能になってないので、コントローラーで使えることを明示する。
  protect_from_forgery with: :exception

end
