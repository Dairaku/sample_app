class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)

    # &&は論理積　ユーザーが存在してかつ、パスワード認証ができるならば
    if user && user.authenticate(params[:session][:password])
       sign_in user 
       # ユーザーをサインインさせ、ユーザーページ (show) にリダイレクトする。 
       # リダイレクトはget
       redirect_back_or user   
    else
      # renderはリクエストではないので、現在のアクションでのみ有効なflash.nowを利用。
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
