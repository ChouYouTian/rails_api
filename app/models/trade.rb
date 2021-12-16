class Trade < ApplicationRecord
    belongs_to:user

    has_many:carts

end
