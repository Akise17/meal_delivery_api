require 'elasticsearch/model'

class Menu < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    belongs_to :restaurant, class_name: "Restaurant", foreign_key: "restaurant_id"
end
