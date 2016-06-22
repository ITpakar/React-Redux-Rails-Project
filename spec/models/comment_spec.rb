require 'rails_helper'

describe Comment do
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
  let (:task_comment) {
    FactoryGirl.create(:comment, organization_user_id: admin.organization_user.id, commentable: task)
  }

  context "callbacks" do
    it "should set deal if deal is not set" do
      comment = Comment.create(FactoryGirl.attributes_for(:comment, :commentable => task, :deal_id => nil))
      expect(comment).to be_persisted
      expect(comment.deal_id).to eql(section.deal_id)
    end

    it "should create event after comment is created" do
      expect {
        Comment.create(:comment => FFaker::Lorem.sentence, :commentable => task)
      }.to change{Comment.count}.by(1)
    end
  end

  describe "#to_hash" do
    it "returns a hash" do
      h = task_comment.to_hash
      expect(h).to be_kind_of(Hash)
      expect(h[:comment_type]).to eql(task_comment.comment_type)
      expect(h[:comment]).to eql(task_comment.comment)
    end

    it "includes user" do
      h = task_comment.to_hash
      expect(h[:user]).to be_present
      expect(h[:user][:id]).to eql(task_comment.organization_user.user.id)
      expect(h[:user][:email]).to eql(task_comment.organization_user.user.email)
    end
  end
end
