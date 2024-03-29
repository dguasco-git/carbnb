class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :car, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :state
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
