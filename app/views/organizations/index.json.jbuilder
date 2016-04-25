json.array!(@organizations) do |organization|
  json.extract! organization, :id, :name, :email, :phone, :address, :created_by, :activated
  json.url organization_url(organization, format: :json)
end
