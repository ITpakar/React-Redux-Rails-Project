require 'rails_helper'

describe Event do
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

  context "callbacks" do
    it "should set deal_id if it is not set" do
      event = Event.create(:eventable => task, :action => "TASK_COMPLETED")
      expect(event).to be_persisted
      expect(event.deal_id).to eql(task.deal_id)
    end
  end

  describe "#title" do
    it "return title" do
      event = Event.create(:eventable => task, :action => "TASK_COMPLETED")
      expect(event.title).to eql(Event::HEADINGS[event.action])
    end
  end
end
