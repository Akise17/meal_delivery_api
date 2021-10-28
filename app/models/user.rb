class User < ApplicationRecord
    devise :database_authenticatable, :registerable, :validatable
   
    has_many :transactions, class_name: "Transaction", foreign_key: "user_id", :dependent => :destroy
    
    accepts_nested_attributes_for :transactions, :allow_destroy => true

    attr_accessor :purchases_attributes, :transactions_attributes

    def email_required? 
        false 
    end
    def will_save_change_to_email? 
        false 
    end 
end
