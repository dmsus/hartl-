class CreateMicroposts < ActiveRecord::Migration
	def change
		create_table :microposts do |t|
			t.taxt :content
			t.references :user, index: true, forign_key: true

			t.timestamps null: false
		end
		add_index :microposts, [:user_id, :created_at]
	end
end