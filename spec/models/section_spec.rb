require 'rails_helper'

describe Section do
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

  context "callbacks" do
    it "set deal_id if deal_id is blank" do
      section = Section.create!(:category_id => deal.categories.last.id, :created_by => admin.id)
      expect(section).to be_persisted
      expect(section.deal_id).to eql(deal.id)
    end
  end

  describe "#to_hash" do
    it "returns a hash" do
      h = section.to_hash
      expect(h).to be_kind_of(Hash)
      expect(h[:name]).to eql(section.name)
      expect(h[:category_id]).to eql(section.category_id)
    end

    it "includes related tasks" do
      tasks = FactoryGirl.create_list(:task, 1 + rand(10), section_id: section.id,
                                  organization_user_id: admin.organization_user.id, :status => "Incomplete")

      h = section.to_hash
      expect(h[:tasks]).to be_kind_of(Array)
      expect(h[:tasks].length).to eql(section.tasks.count)
    end
  end
end
