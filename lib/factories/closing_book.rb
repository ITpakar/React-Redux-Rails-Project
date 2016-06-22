FactoryGirl.define do
  factory :closing_book do
    status                   { ClosingBook::STATUSES.sample }
    index_type               {ClosingBook::INDEX_TYPES.sample}
    url                      {FFaker::Internet.http_url}
  end
end
