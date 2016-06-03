class DealDocument < ApplicationRecord
  belongs_to :document
  belongs_to :documentable, polymorphic: true
end
