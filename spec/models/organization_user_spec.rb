require 'rails_helper'

describe OrganizationUser do
  let(:owner) {FactoryGirl.create(:owner, :with_confirmed_email)}
  let(:organization) { FactoryGirl.create(:organization, :created_by => owner.id)}
  let(:user) {
    FactoryGirl.create(:user, :with_organization_user, :with_confirmed_email,
                              :organization_id => organization.id)
  }
  let(:deal) {FactoryGirl.create(:deal, :organization => organization, :organization_user => user.organization_user)}

  context "callbacks" do
    it "set type automatically" do
      user = create_user
      ou = OrganizationUser.create(:user => user, :organization => organization)
      expect(ou).to be_persisted
      expect(ou.type).to be_present
    end

    it "set type to EXTERNAL if user's email domain is not the same with organization's email domain" do
      og_email_domain = "doxly.com"
      user_email = "#{("a".."z").to_a.sample(5).join}@sample.com"

      organization.update_attributes!(:email_domain => og_email_domain)
      user = create_user(user_email)
      ou = OrganizationUser.create(:user => user, :organization => organization)
      expect(ou).to be_persisted
      expect(ou.type).to eql("External")
    end

    it "set type to INTERNAL if user's email domain is the same with organization's email domain" do
      user_email = "#{("a".."z").to_a.sample(5).join}@#{organization.email_domain}"
      user = User.create!(:first_name => FFaker::Name.first_name,
                         :last_name => FFaker::Name.last_name,
                         :email => user_email,
                         :role => User::ROLES.first,
                         :password => "12341234")
      ou = OrganizationUser.create(:user => user, :organization => organization)
      expect(ou).to be_persisted
      expect(ou.type).to eql("Internal")
    end
  end

  describe "#is_external?" do
    it "returns true for external user" do
      og_email_domain = "doxly.com"
      user_email = "#{("a".."z").to_a.sample(5).join}@sample.com"

      organization.update_attributes!(:email_domain => og_email_domain)
      user = create_user(user_email)
      ou = OrganizationUser.create(:user => user, :organization => organization)
      expect(ou.is_external?).to be_truthy
    end

    it "returns false for internal user" do
      user_email = "#{("a".."z").to_a.sample(5).join}@#{organization.email_domain}"
      user = create_user(user_email)
      ou = OrganizationUser.create(:user => user, :organization => organization)
      expect(ou.is_external?).to be_falsy
    end
  end

  describe "#is_internal?" do
    it "returns false for external user" do
      og_email_domain = "doxly.com"
      user_email = "#{("a".."z").to_a.sample(5).join}@sample.com"

      organization.update_attributes!(:email_domain => og_email_domain)
      user = create_user(user_email)
      ou = OrganizationUser.create(:user => user, :organization => organization)
      expect(ou.is_internal?).to be_falsy
    end

    it "returns true for internal user" do
      user_email = "#{("a".."z").to_a.sample(5).join}@#{organization.email_domain}"
      user = create_user(user_email)
      ou = OrganizationUser.create(:user => user, :organization => organization)
      expect(ou.is_internal?).to be_truthy
    end
  end

  describe "#star!" do
    it "creates starred deal" do
      expect{
        user.organization_user.star!(deal)
      }.to change{StarredDeal.count}.by(1)
      expect(StarredDeal.where(:organization_user_id => user.organization_user.id, :deal_id => deal.id).count).to eql(1)
    end
  end

  describe "#is_deal_collaborator?" do
    it "returns true if user is deal collaborator" do
      collaborator = DealCollaborator.create(:deal_id => deal.id,
                                  :organization_user => user.organization_user,
                                  :added_by => user.organization_user.id)
      expect(user.organization_user.is_deal_collaborator?(deal)).to be_truthy
    end

    it "returns false if user is not deal collaborator" do
      other_user = FactoryGirl.create(:user, :with_organization_user, :with_confirmed_email,
                                :organization_id => organization.id)
      expect(other_user.organization_user.is_deal_collaborator?(deal)).to be_falsy
    end
  end
end

def create_user(email = nil)
  email = email || FFaker::Internet.email
  User.create!(:first_name => FFaker::Name.first_name,
                     :last_name => FFaker::Name.last_name,
                     :email => email,
                     :role => User::ROLES.first,
                     :password => "12341234")
end
