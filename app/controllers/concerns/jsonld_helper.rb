module JSONLDHelper
  def json_ld(graph)
    json_ld = nil
    JSON::LD::API.fromRDF(graph) do |expanded|
      json_ld = JSON::LD::API.compact(expanded, nil)
    end
    json_ld.to_json
  end
end
