class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :access_token
      t.string :user_id
      t.string :expires_at

      t.timestamps null: false
    end
  end
end