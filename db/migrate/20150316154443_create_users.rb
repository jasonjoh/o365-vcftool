class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.text :access_token
      t.text :refresh_token
      t.timestamp :token_expires

      t.timestamps null: false
    end
  end
end
