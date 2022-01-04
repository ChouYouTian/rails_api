class CheckTradeJob < ApplicationJob
  queue_as :default

  def perform(trade_id)
    trade=Trade.eager_load(carts: :product).find(trade_id)

    if trade[:state]=="paying" ||trade[:state]=="start"

      trade.carts.each do |cart|
        product=cart.product

        if product
          product[:quantity]+=cart[:amount]
          product.save
        end

        cart.cancel!
      end
      trade.cancel!
    end
  end
end
