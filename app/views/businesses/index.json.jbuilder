json.array!(@businesses) do |business|
  json.extract! business, :id, :name, :quantity
  json.url business_url(business, format: :json)
end
