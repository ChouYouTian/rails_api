class Cart < ApplicationRecord
    belongs_to:user  
    belongs_to:product
    belongs_to:trade

    def intrade!
        self[:state]="intrade"
        self.save
    end

    def cancel!
        self[:state]="cancel"
        self.save
    end
    
    def fail!
        self[:state]="fail"
        self.save
    end

    def finish!
        self[:state]='finish'
        self.save
    end
end
