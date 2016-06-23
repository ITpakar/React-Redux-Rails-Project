FactoryGirl.define do
  factory :closing_book do
    status                   { ClosingBook::STATUSES.sample }
    index_type               {ClosingBook::INDEX_TYPES.sample}
  end
end
