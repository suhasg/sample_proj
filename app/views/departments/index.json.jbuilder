json.array!(@departments) do |department|
  json.extract! department, :id, :name, :code, :location, :in_charge
  json.url department_url(department, format: :json)
end
