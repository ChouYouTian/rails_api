class Trade < ApplicationRecord
    belongs_to:user

    has_many:carts

    def fail!
        self[:state]='fail'
        self.save
    end
    
    def finish!
        self[:state]='finish'
        self.save
    end
    
    def paying!
        self[:state]='paying'
        self.save
    end

    def paid!
        self[:state]='paid'
        self.save
    end

    def  shipping!
        self[:state]='shipping'
        self.save
    end


end
