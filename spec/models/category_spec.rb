require 'rails_helper'

describe Category do
  let(:owner) {FactoryGirl.create(:owner, :with_confirmed_email)}
  let(:organization) { FactoryGirl.create(:organization, :created_by => owner.id)}
  let(:admin) {
    FactoryGirl.create(:user, :with_organization_admin_user, :with_confirmed_email,
                              :organization_id => organization.id)
  }
  let(:deal) {FactoryGirl.create(:deal, :organization => organization, :organization_user => admin.organization_user)}

  context "validations" do
    it "should allow to create category with valid attributes" do
      category = Category.create(FactoryGirl.attributes_for(:category))
      expect(category).to be_persisted
    end

    it {should validate_length_of(:name)}
  end

  describe "#to_hash" do
    let(:category) {FactoryGirl.create(:category, :deal => deal)}

    it "returns a hash" do
      h = category.to_hash
      expect(h).to be_kind_of(Hash)
      expect(h["id"]).to eql(category.id)
      expect(h["name"]).to eql(category.name)
    end

    it "includes related sections" do
      h = category.to_hash
      expect(h[:sections]).to be_kind_of(Array)
      expect(h[:sections].length).to eql(category.sections.count)
    end
  end
end
