class OrganizationInternalUser < OrganizationUser
  def self.sti_name
    "Internal"
  end
end
