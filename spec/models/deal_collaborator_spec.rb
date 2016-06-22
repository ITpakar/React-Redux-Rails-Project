require 'rails_helper'

describe DealCollaborator do
  let(:owner) {FactoryGirl.create(:owner, :with_confirmed_email)}
  let(:organization) { FactoryGirl.create(:organization, :created_by => owner.id)}
  let(:admin) {
    FactoryGirl.create(:user, :with_organization_admin_user, :with_confirmed_email,
                              :organization_id => organization.id)
  }
  let(:user) {
    FactoryGirl.create(:user, :with_organization_user, :with_confirmed_email,
                              :organization_id => organization.id)
  }
  let(:deal) {FactoryGirl.create(:deal, :organization => organization, :organization_user => admin.organization_user)}
  let(:collaborator) {
    DealCollaborator.create(:deal_id => deal.id,
                            :organization_user => user.organization_user,
                            :added_by => admin.organization_user.id)
  }

  context "callbacks" do
    it "should set type if it is not set" do
      expect(collaborator).to be_persisted
      expect(collaborator.type).to be_present
    end
  end

  describe "#to_hash" do
    it "returns a hash" do
      h = collaborator.to_hash
      expect(h).to be_kind_of(Hash)
    end
  end
end
