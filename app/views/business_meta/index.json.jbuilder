json.array!(@business_meta) do |business_metum|
  json.extract! business_metum, :id, :name, :redeem_number, :location, :phone, :logo
  json.url business_metum_url(business_metum, format: :json)
end
