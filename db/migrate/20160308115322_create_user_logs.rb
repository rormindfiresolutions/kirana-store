class CreateUserLogs < ActiveRecord::Migration
  def change
    create_table :user_logs do |t|
    	t.date :log
    	t.string :details
    	t.references :user, foreign_key: true
    	
      t.timestamps null: false
    end
  end
end
