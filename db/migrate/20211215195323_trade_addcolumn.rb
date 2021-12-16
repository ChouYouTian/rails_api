class TradeAddcolumn < ActiveRecord::Migration[6.1]
  def change
    add_column :trades,:total_price,:integer,:null=>false
  end
end
