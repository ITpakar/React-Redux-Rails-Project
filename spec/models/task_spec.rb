require 'rails_helper'

describe Task do
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
                              organization_user_id: admin.organization_user.id,
                              status: "Incomplete")
  }
  let(:document) {
        FactoryGirl.create(:document, :with_deal_document,
                              documentables: [task],
                              organization_user: admin.organization_user,
                              creator: admin.organization_user)
  }

  context "callbacks" do
    it "set deal_id if deal_id is blank" do
      task = Task.create(
        :title => FFaker::Name.name,
        :description => FFaker::Lorem.sentence,
        :section_id => section.id,
        :organization_user_id => admin.organization_user.id
      )
      expect(task).to be_persisted
      expect(task.deal_id).to eql(deal.id)
    end
  end

  describe "#create_event_if_complete" do
    it "creates event when status is changed to Complete" do
      expect {
        task.update_attributes!(:status => "Complete")
      }.to change{Event.where(:eventable => task).count}.by(1)
    end

    it "does not create event if status is not changed" do
      expect {
        task.update_attributes!(:title => FFaker::Name.name)
      }.to change{Event.where(:eventable => task).count}.by(0)
    end

    it "does not create event if status is changed to Incomplete" do
      task = Task.create!(
        :title => FFaker::Name.name,
        :description => FFaker::Lorem.sentence,
        :section_id => section.id,
        :organization_user_id => admin.organization_user.id,
        :status => "Complete"
      )

      expect {
        task.update_attributes!(:status => "Incomplete")
      }.to change{Event.where(:eventable => task).count}.by(0)
    end
  end

  describe "#complete!" do
    it "changes status to Complete" do
      task.complete!
      expect(task.status).to eql("Complete")
    end
  end

  describe "#to_hash" do
    it "returns a hash" do
      h = task.to_hash
      expect(h).to be_kind_of(Hash)
      expect(h[:title]).to eql(task.title)
      expect(h[:description]).to eql(task.description)
    end
  end
end
