class AddTradeTradeNo < ActiveRecord::Migration[6.1]
  def change
    add_column :trades,:trade_no,:string
    end
end
