require 'rails_helper'

describe Organization do
  let(:owner) {FactoryGirl.create(:owner, :with_confirmed_email)}
  let(:organization) { FactoryGirl.create(:organization, :created_by => owner.id)}

  context "callbacks" do
    it "creates organization internal user" do
      expect {
        organization
      }.to change{OrganizationInternalUser.count}.by(1)
    end

    it {should validate_length_of(:name)}
  end

  describe "#to_hash" do
    it "returns a hash" do
      h = organization.to_hash
      expect(h).to be_kind_of(Hash)
      expect(h[:name]).to eql(organization.name)
      expect(h[:email_domain]).to eql(organization.email_domain)
    end

    it "includes creator" do
      h = organization.to_hash
      expect(h[:admin]).to be_present
      expect(h[:admin][:id]).to eql(owner.id)
      expect(h[:admin][:email]).to eql(owner.email)
    end
  end
end
