module Services
    class EcsService
        require 'elasticsearch'

        def self.index(indexing, data)
            client = Elasticsearch::Client.new
            @response = client.index(index: indexing, body: data)
        end
        
        def self.search(index, q, body)
            client = Elasticsearch::Client.new
            @response = client.search(index: index, q: q, body: body)
        end
        
    end
end