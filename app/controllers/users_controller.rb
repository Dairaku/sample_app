class UsersController < ApplicationController
  before_action :signed_in_user,
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  # deleteの前に、admin_userかどうか確かめる。
  before_action :admin_user,     only: :destroy


  def new
    # フォームにいれるインスタンス変数を生成
  	@user = User.new 
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      
      #flashはredirect_toと一緒に使う。
    	flash[:success] = "Welcome to the Sample App!"

      # user_path(@user.id)を省力して。user#showアクションへ。
    	redirect_to @user 
    else
      # 同じコントローラーのviewのテンプレートを呼び出す。
      render 'new' 
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    # サインアップのフォームから送られてきたuser情報の中から必要なものだけを許可。(ストロングパラメーター)
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end

