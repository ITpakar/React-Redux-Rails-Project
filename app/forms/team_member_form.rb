class TeamMemberForm
  include ActiveModel::Validations

  attr_accessor :first_name, :last_name, :email, :organization

  validates_presence_of :first_name, :last_name, :organization
  validates_format_of :email, :with => Devise::email_regexp
  validate :email_domain


  def initialize(attrs = {})
    attrs.each do |k, v|
      self.send("#{k}=", v)
    end
  end

  private

  def email_domain
    if self.email.present? && self.organization.present?
      str = "@#{organization.email_domain}"
      self.errors.add(:email, "must end with #{organization.email_domain}") unless self.email.end_with?(str)
    end
  end
end
