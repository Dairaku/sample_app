class AddPasswordDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string　#usersテーブルにpassword_digest(string型)を追加。
  end
end
