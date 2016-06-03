class OrganizationExternalUser < OrganizationUser
  def self.sti_name
    "External"
  end
end
