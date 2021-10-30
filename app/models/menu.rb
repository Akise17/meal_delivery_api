require 'elasticsearch/model'

class Menu < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
end
