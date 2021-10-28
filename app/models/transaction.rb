class Transaction < ApplicationRecord
    alias_attribute :date, :purchase_date
    
end
