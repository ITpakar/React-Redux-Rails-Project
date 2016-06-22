require 'rails_helper'

describe Folder do
  let(:owner) {FactoryGirl.create(:owner, :with_confirmed_email)}
  let(:organization) { FactoryGirl.create(:organization, :created_by => owner.id)}
  let(:admin) {
    FactoryGirl.create(:user, :with_organization_admin_user, :with_confirmed_email,
                              :organization_id => organization.id)
  }
  let(:deal) {FactoryGirl.create(:deal, :organization => organization, :organization_user => admin.organization_user)}
  let(:section) {
    FactoryGirl.create(:section, category_id: deal.categories.first.id,
                          created_by: admin.id, deal_id: deal.id)

  }
  let(:task) {
    FactoryGirl.create(:task, section_id: section.id,
                              organization_user_id: admin.organization_user.id)
  }
  let(:folder) {
    FactoryGirl.create(:folder, :task => task)
  }
  let(:document) {
        FactoryGirl.create(:document, :with_deal_document,
                              documentables: [folder],
                              organization_user: admin.organization_user,
                              creator: admin.organization_user)
  }

  context "validations" do
    it "sets deal id if it's blank" do
      folder = Folder.create(FactoryGirl.attributes_for(:folder, :task => task, :deal_id => nil))
      expect(folder).to be_persisted
      expect(folder.deal_id).to eql(deal.id)
    end
  end

  describe "#to_hash" do
    it "returns a hash" do
      h = folder.to_hash
      expect(h).to be_kind_of(Hash)
      expect(h[:name]).to eql(folder.name)
    end

    it "includes related documents and creator" do
      document
      folder = FactoryGirl.create(:folder, :task => task, :created_by => admin.organization_user.id)
      h = folder.to_hash
      expect(h[:documents]).to be_kind_of(Array)
      expect(h[:documents].length).to eql(folder.documents.count)

      expect(h[:creator]).to be_present
      expect(h[:creator][:id]).to eql(admin.id)
      expect(h[:creator][:email]).to eql(admin.email)
    end
  end
end
