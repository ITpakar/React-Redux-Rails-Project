module HasVisibility
  extend ActiveSupport::Concern

  included do
    # Enum declaration for visibility field - You can use (for example) Task.first.internal_visibility? or Task.last.external_visibility! 
    enum visibility: %w(internal external), _suffix: true 
  end
end