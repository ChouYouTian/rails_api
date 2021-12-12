class User < ApplicationRecord
    has_many:products
    has_many:carts
    has_many:trades
end
