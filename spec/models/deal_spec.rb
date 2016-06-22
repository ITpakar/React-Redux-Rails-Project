require 'rails_helper'

describe Deal do
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
  let(:diligence_section) {
    FactoryGirl.create(:section, category_id: deal.diligence_category.id,
                          created_by: admin.id, deal_id: deal.id)

  }
  let(:closing_section) {
    FactoryGirl.create(:section, category_id: deal.closing_category.id,
                          created_by: admin.id, deal_id: deal.id)

  }

  context "callbacks" do
    it "sets default status if status is blank" do
      deal = Deal.create(FactoryGirl.attributes_for(:deal, :status => nil, :organization_user => admin.organization_user))
      expect(deal).to be_persisted
      expect(deal.status).to be_present
    end

    it "sets default organization_id if it is blank" do
      deal = Deal.create(FactoryGirl.attributes_for(:deal, :status => nil, :organization_user => admin.organization_user, :organization => nil))
      expect(deal).to be_persisted
      expect(deal.organization_id).to be_present
    end

    it "creates notification if close" do
      expect {
        deal.update_attributes(:status => "Closed")
      }.to change{Event.count}.by(1)
    end

    it "creates deal collaborator after create" do
      expect(deal.deal_collaborators.count).to eql(1)
    end

    it "creates diligence category and closing category after creat" do
      deal_attrs = FactoryGirl.attributes_for(:deal, :organization => organization, :organization_user => admin.organization_user)
      diligence_count = DiligenceCategory.count
      closing_count = ClosingCategory.count
      d = Deal.create(deal_attrs)

      expect(DiligenceCategory.count).to eql(diligence_count + 1)
      expect(DiligenceCategory.where(:deal_id => d.id).count).to eql(1)

      expect(ClosingCategory.count).to eql(closing_count + 1)
      expect(ClosingCategory.where(:deal_id => d.id).count).to eql(1)
    end
  end

  describe "#add_collaborator!" do
    it "adds user" do
      deal
      expect {
        deal.add_collaborator!(user.organization_user, admin.organization_user)
      }.to change{DealCollaborator.count}.by(1)
    end

    it "does not adds user if user already added" do
      deal.add_collaborator!(user.organization_user, admin.organization_user)
      expect {
        deal.add_collaborator!(user.organization_user, admin.organization_user)
      }.to change{DealCollaborator.count}.by(0)
    end
  end

  describe "#invite_collaborator" do
    it "creates invite" do
      email = FFaker::Internet.email
      expect {
        deal.invite_collaborator(email, admin.organization_user)
      }.to change{DealCollaboratorInvite.count}.by(1)
    end

    it "does not invites user if user already invites" do
      email = FFaker::Internet.email
      deal.invite_collaborator(email, admin.organization_user)
      expect {
        deal.invite_collaborator(email, admin.organization_user)
      }.to change{DealCollaboratorInvite.count}.by(0)
    end

    it "does not invites existing collaborator" do
      email = deal.collaborators.first.email
      expect {
        deal.invite_collaborator(email, admin.organization_user)
      }.to change{DealCollaboratorInvite.count}.by(0)
    end
  end

  describe "#completion_percent" do
    it "returns 0 if no tasks are present" do
      Task.delete_all
      expect(deal.completion_percent).to eql(0)
    end

    it "returns correct percent" do
      Task.delete_all
      tasks = FactoryGirl.create_list(:task, 1 + rand(10), section_id: [diligence_section.id, closing_section.id].sample,
                                  organization_user_id: user.organization_user.id, :status => "Incomplete")
      completed_tasks = tasks.sample(rand(tasks.length))
      completed_tasks.each{|t| t.update_attributes!(:status => "Complete")}

      expect(deal.completion_percent).to eql((100*completed_tasks.length.to_f/tasks.length).round(2))
    end
  end

  describe "#diligence_completion_percent" do
    it "returns 0 if no tasks are present" do
      Task.delete_all
      expect(deal.diligence_completion_percent).to eql(0)
    end

    it "returns correct percent" do
      Task.delete_all
      tasks = FactoryGirl.create_list(:task, 1 + rand(10), section_id: diligence_section.id,
                                  organization_user_id: user.organization_user.id, :status => "Incomplete")
      completed_tasks = tasks.sample(rand(tasks.length))
      completed_tasks.each{|t| t.update_attributes!(:status => "Complete")}

      expect(deal.diligence_completion_percent).to eql((100*completed_tasks.length.to_f/tasks.length).round(2))
    end
  end

  describe "#closing_completion_percent" do
    it "returns 0 if no tasks are present" do
      Task.delete_all
      expect(deal.diligence_completion_percent).to eql(0)
    end

    it "returns correct percent" do
      Task.delete_all
      tasks = FactoryGirl.create_list(:task, 1 + rand(10), section_id: closing_section.id,
                                  organization_user_id: user.organization_user.id, :status => "Incomplete")
      completed_tasks = tasks.sample(rand(tasks.length))
      completed_tasks.each{|t| t.update_attributes!(:status => "Complete")}

      expect(deal.closing_completion_percent).to eql((100*completed_tasks.length.to_f/tasks.length).round(2))
    end
  end

  describe "#to_hash" do
    it "returns a hash" do
      h = deal.to_hash
      expect(h).to be_kind_of(Hash)
      expect(h[:title]).to eql(deal.title)
      expect(h[:deal_size]).to eql(deal.deal_size)
    end

    it "includes user" do
      h = deal.to_hash
      expect(h[:admin]).to be_present
      expect(h[:admin][:id]).to eql(deal.organization_user.user.id)
      expect(h[:admin][:email]).to eql(deal.organization_user.user.email)
    end
  end
end
