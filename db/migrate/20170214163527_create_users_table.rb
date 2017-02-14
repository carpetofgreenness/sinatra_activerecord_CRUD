class CreateUsersTable < ActiveRecord::Migration[5.0]
  def change
  	create_table :users do |t|
  		t.string :name
  		t.string :email
  		t.string :password
  		t.text :quote
  		t.string :profpic
  	end
  end
end
