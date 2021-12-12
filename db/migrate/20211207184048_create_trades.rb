class CreateTrades < ActiveRecord::Migration[6.1]
  def change
    create_table :trades do |t|

      t.string:state
      t.text:detail

      t.timestamps
    end
  end
end
