class ApiService

  def self.get_info(uri)
    response = Faraday.get(uri)
    if response.class == String || response.class == Hash
      parsed = []
    else
      parsed = JSON.parse(response.body, symbolize_names: true)
    end
  end
end
