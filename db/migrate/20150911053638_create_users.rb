class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t| #create_tableはRailsのメソッド
      t.string :name
      t.string :email

      t.timestamps #created_atとupdated_atという2つの「マジックカラム」を作成する。
    end
  end
end
