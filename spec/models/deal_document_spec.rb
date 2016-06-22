require 'rails_helper'

describe DealDocument do
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
  let(:section) {
    FactoryGirl.create(:section, category_id: deal.categories.first.id,
                          created_by: user.id, deal_id: deal.id)

  }
  let(:task) {
    FactoryGirl.create(:task, section_id: section.id,
                              organization_user_id: user.organization_user.id)
  }
  let(:document) {
        FactoryGirl.create(:document, :with_deal_document,
                              documentables: [task],
                              organization_user: user.organization_user,
                              creator: user.organization_user)
  }

  let(:deal_document) {
    document.deal_documents.first
  }

  context "callbacks" do
    it "should set deal_id if it is not set" do
      document = Document.create(:title => FFaker::Name.name)
      dd = document.deal_documents.create!(:documentable => task)
      expect(dd.deal_id).to eql(task.deal_id)
    end
  end

  describe "#to_hash" do
    it "returns a hash" do
      h = deal_document.to_hash
      expect(h).to be_kind_of(Hash)
      expect(h[:id]).to eql(deal_document.id)
      expect(h[:documentable_id]).to eql(deal_document.documentable_id)
      expect(h[:documentable_type]).to eql(deal_document.documentable_type)
    end
  end

  describe "#upcoming_version" do
    it "returns 1.0 for first version" do
      expect(deal_document.upcoming_version).to eql("1.0")
    end

    it "returns 2.0 for second version" do
      deal_document.versions.create(:name => deal_document.upcoming_version)
      expect(deal_document.upcoming_version).to eql("2.0")
    end
  end
end
