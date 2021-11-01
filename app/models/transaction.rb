class Transaction < ApplicationRecord
    alias_attribute :date, :purchase_date
    belongs_to :user, class_name: "User", foreign_key: "user_id"
    
end
