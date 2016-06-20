namespace :reporting do
  task generate_kpis: :environment do
    Organization.all.each do |organization|
      # Create a snapshot of the organizations deals by deal type
      Deal::TRANSACTION_TYPES.each do |transaction_type|
        deals = organization.deals.where(transaction_type: transaction_type)
        key = "#{transaction_type} Count"
        value = deals.count
        puts "Creating KPI for organization #{organization.id} with key #{key} and value #{value}"
        Kpi.create(organization_id: organization.id, key: "#{transaction_type} Count", value: value)

        key = "#{transaction_type} Size"
        value = deals.map(&:deal_size).sum
        puts "Creating KPI for organization #{organization.id} with key #{key} and value #{value}"
        Kpi.create(organization_id: organization.id, key: "#{transaction_type} Count", value: value)
      end
    end
  end
end