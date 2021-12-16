class Cart < ApplicationRecord
    belongs_to:user  
    belongs_to:product
    belongs_to:trade
end
