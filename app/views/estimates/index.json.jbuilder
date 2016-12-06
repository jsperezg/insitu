json.estimates @estimates.each do |estimate|
  json.cache! estimate do
    json.extract! estimate, :id, :number, :customer_id, :estimate_status_id, :date, :valid_until
    json.estimate_details estimate.estimate_details do |detail|
      json.cache! detail do
        json.extract! detail, :id, :service_id, :description, :quantity, :price, :discount, :invoice_detail_id
      end
    end
  end
end
