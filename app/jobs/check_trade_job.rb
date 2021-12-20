class CheckTradeJob < ApplicationJob
  queue_as :default

  def perform(trade_id)
    trade=Trade.find(trade_id)

    if trade[:state]=="paying" ||trade[:state]=="start"
      trade.cancel!
    end
  end
end
