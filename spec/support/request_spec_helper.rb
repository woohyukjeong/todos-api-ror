module RequestSpecHelper
  # Parse JSON Response to Ruby hash
  def json
    JSON.parse(response.body)
  end
end
