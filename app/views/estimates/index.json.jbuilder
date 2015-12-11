json.array!(@estimates) do |estimate|
  json.extract! estimate, :id
  json.url estimate_url(estimate, format: :json)
end
