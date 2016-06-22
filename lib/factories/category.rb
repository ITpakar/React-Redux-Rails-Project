FactoryGirl.define do
  factory :category do
    name                   { [ClosingCategory.name, DiligenceCategory.name].sample}
    activated              true
    deal
  end

  factory :diligence_category, :parent => :category do
    name {DiligenceCategory.name}
  end

  factory :closing_category, :parent => :category do
    name {ClosingCategory.name}
  end
end
