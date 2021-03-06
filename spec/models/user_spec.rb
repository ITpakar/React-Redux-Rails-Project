require 'rails_helper'

describe User do
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

  context "validations" do
    it "should allow to create user with valid attributes" do
      user = User.create(FactoryGirl.attributes_for(:user))
      expect(user).to be_persisted
    end

    it {should validate_presence_of(:first_name)}
    it {should validate_presence_of(:last_name)}
    it {should validate_presence_of(:email)}
    it {should validate_length_of(:phone)}
    it {should validate_length_of(:company)}
    it {should validate_inclusion_of(:role).in_array([USER_SUPER, USER_NORMAL])}
  end

  describe "#is_organization_admin?" do
    it "should return true if user is owner" do
      expect(owner.is_organization_admin?(organization.id)).to be_truthy
    end

    it "returns true if user is organization admin" do
      expect(admin.is_organization_admin?(organization.id)).to be_truthy
    end

    it "returns false if user is just normal organization user" do
      expect(user.is_organization_admin?(organization.id)).to be_falsy
    end
  end

  describe "#is_organization_member?" do
    it "should return true if user is owner" do
      expect(owner.is_organization_member?(organization.id)).to be_truthy
    end

    it "returns true if user is organization admin" do
      expect(admin.is_organization_member?(organization.id)).to be_truthy
    end

    it "returns false if user is just normal organization user" do
      expect(user.is_organization_member?(organization.id)).to be_truthy
    end
  end

  describe "#is_org_deal_admin?" do
    let(:deal_admin) {FactoryGirl.create(:user, :with_organization_user, :with_confirmed_email,
                                :organization_id => organization.id)}
    let(:deal) {FactoryGirl.create(:deal, :organization => organization, :organization_user => deal_admin.organization_user)}

    it "should return true if user is owner" do
      expect(owner.is_org_deal_admin?(deal.id)).to be_truthy
    end

    it "returns true if user create deal" do
      expect(deal_admin.is_org_deal_admin?(deal.id)).to be_truthy
    end

    it "returns false if user is not owner and user did not create deal" do
      expect(user.is_org_deal_admin?(deal.id)).to be_falsy
    end
  end

  describe "#is_deal_admin?" do
    let(:deal_admin) {FactoryGirl.create(:user, :with_organization_user, :with_confirmed_email,
                                :organization_id => organization.id)}
    let(:deal) {FactoryGirl.create(:deal, :organization => organization, :organization_user => deal_admin.organization_user)}

    it "should return true if user is owner" do
      expect(owner.is_deal_admin?(deal)).to be_truthy
    end

    it "returns true if user create deal" do
      expect(deal_admin.is_deal_admin?(deal)).to be_truthy
    end

    it "returns true if user is admin of the organization that creates deal" do
      expect(admin.is_deal_admin?(deal)).to be_truthy
    end

    it "returns false if user is a normal member of the organization that creates deal" do
      expect(user.is_deal_admin?(deal)).to be_falsy
    end
  end

  describe "#is_deal_collaborator?" do
    let(:deal_admin) {FactoryGirl.create(:user, :with_organization_user, :with_confirmed_email,
                                :organization_id => organization.id)}
    let(:deal) {FactoryGirl.create(:deal, :organization => organization, :organization_user => deal_admin.organization_user)}

    it "should return true if user is owner" do
      expect(owner.is_deal_collaborator?(deal)).to be_truthy
    end

    it "returns true if user create deal" do
      expect(deal_admin.is_deal_collaborator?(deal)).to be_truthy
    end

    it "returns true if user is deal collaborator" do
      DealCollaborator.create!(:deal_id => deal.id, :organization_user_id => user.organization_user.id)
      expect(user.is_deal_collaborator?(deal)).to be_truthy
    end

    it "returns false if user is admin of the organization that creates deal" do
      expect(admin.is_deal_collaborator?(deal)).to be_falsy
    end

    it "returns false if user is a normal member of the organization that creates deal" do
      expect(user.is_deal_collaborator?(deal)).to be_falsy
    end
  end

  describe "#is_document_owner?" do
    let(:document_creator) {
          FactoryGirl.create(:user, :with_organization_user, :with_confirmed_email,
                                    :organization_id => organization.id)
    }
    let(:deal_admin) {FactoryGirl.create(:user, :with_organization_user, :with_confirmed_email,
                                :organization_id => organization.id)}
    let(:deal) {
      FactoryGirl.create(:deal, :from_the_past, organization_user: deal_admin.organization_user)
    }
    let(:section) {
      FactoryGirl.create(:section, category_id: deal.categories.first.id,
                            created_by: document_creator.id, deal_id: deal.id)
    }
    let(:task) {
      FactoryGirl.create(:task, section_id: section.id,
                                organization_user_id: document_creator.organization_user.id)
    }
    let(:document) {
          FactoryGirl.create(:document, :with_deal_document,
                                documentables: [task],
                                organization_user: deal_admin.organization_user,
                                creator: document_creator.organization_user)
    }

    it "returns true if user is owner" do
      expect(owner.is_document_owner?(document.id)).to be_truthy
    end

    it "returns true if user is the creator" do
      expect(document_creator.is_document_owner?(document.id)).to be_truthy
    end

    it "returns false if user is the admin of the organization" do
      user = FactoryGirl.create(:user, :with_organization_admin_user, :with_confirmed_email,
                                  :organization_id => organization.id)
      expect(user.is_document_owner?(document.id)).to be_falsy
    end

    it "returns false if user is deal admin" do
      expect(deal_admin.is_document_owner?(document.id)).to be_falsy
    end
  end

  describe "#is_comment_owner?" do
    let(:document_creator) {
          FactoryGirl.create(:user, :with_organization_user, :with_confirmed_email,
                                    :organization_id => organization.id)
    }
    let(:deal_admin) {FactoryGirl.create(:user, :with_organization_user, :with_confirmed_email,
                                :organization_id => organization.id)}
    let(:deal) {
      FactoryGirl.create(:deal, :from_the_past, organization_user: deal_admin.organization_user)
    }
    let(:section) {
      FactoryGirl.create(:section, category_id: deal.categories.first.id,
                            created_by: document_creator.id, deal_id: deal.id)

    }
    let(:task) {
      FactoryGirl.create(:task, section_id: section.id,
                                organization_user_id: document_creator.organization_user.id)
    }
    let(:document) {
          FactoryGirl.create(:document, :with_deal_document,
                                documentables: [task],
                                organization_user: deal_admin.organization_user,
                                creator: document_creator.organization_user)
    }
    let (:task_comment) {
      FactoryGirl.create(:comment, organization_user_id: document_creator.organization_user.id, commentable: task)
    }
    let(:document_comment) {
      FactoryGirl.create(:comment, organization_user_id: document_creator.organization_user.id,
                                   commentable: document.deal_documents.where(documentable: task).first)
    }

    it "returns true if user is owner" do
      expect(owner.is_comment_owner?(task_comment.id)).to be_truthy
      expect(owner.is_comment_owner?(document_comment.id)).to be_truthy
    end

    it "returns true if user is the creator" do
      expect(document_creator.is_comment_owner?(task_comment.id)).to be_truthy
      expect(document_creator.is_comment_owner?(document_comment.id)).to be_truthy
    end

    it "returns false if user is the admin of the organization" do
      expect(admin.is_comment_owner?(task_comment.id)).to be_falsy
      expect(admin.is_comment_owner?(document_comment.id)).to be_falsy
    end

    it "returns false if user is deal admin" do
      expect(deal_admin.is_comment_owner?(task_comment.id)).to be_falsy
      expect(deal_admin.is_comment_owner?(document_comment.id)).to be_falsy
    end
  end

  describe "#is_notification_receiver?" do
    let(:creator) {
          FactoryGirl.create(:user, :with_organization_user, :with_confirmed_email,
                                    :organization_id => organization.id)
    }
    let(:notification) {Notification.create!(:organization_user => creator.organization_user,
                                              :message => FFaker::Lorem.sentences.join(". "))}

    it "returns true if user is owner" do
      expect(owner.is_notification_receiver?(notification.id)).to be_truthy
    end

    it "returns true if user is the creator" do
      expect(creator.is_notification_receiver?(notification.id)).to be_truthy
    end

    it "returns false if user is the admin of the organization" do
      expect(admin.is_notification_receiver?(notification.id)).to be_falsy
    end

    it "returns false if user is normal member" do
      expect(user.is_notification_receiver?(notification.id)).to be_falsy
    end
  end

  describe "#to_hash" do
    it "returns a hash" do
      h = user.to_hash
      expect(h).to be_kind_of(Hash)
      expect(h[:first_name]).to be_present
      expect(h[:last_name]).to be_present
      expect(h[:email]).to be_present
      expect(h[:id]).to eql(user.id)
    end

    it "allow to add organization to the returned hash" do
      h = user.to_hash(true)
      expect(h[:organization]).to be_present
    end
  end

  describe "#email_domain" do
    it "returns domain of user's email" do
      expect(user.email_domain).to eql(user.email.split("@").last)
    end
  end

  describe ".enterprise_box_client" do
    it "returns Boxr::Client" do
      expect(User.enterprise_box_client).to be_kind_of(Boxr::Client)
    end

    it "uses Boxr's enterprise token" do
      token = double(:token)
      access_token = ("a".."z").to_a.sample(10).join
      allow(token).to receive(:access_token).and_return access_token
      expect(Boxr).to receive(:get_enterprise_token).and_return(token)
      expect(Boxr::Client).to receive(:new).with(access_token)

      User.enterprise_box_client
    end
  end

  describe "#box_client" do
    it "returns Boxr::Client" do
      expect(user.box_client).to be_kind_of(Boxr::Client)
    end

    it "uses Boxr's get user token" do
      client = double(:client)
      expect(User).to receive(:enterprise_box_client).and_return(client)
      allow(client).to receive(:create_user).and_return(user)

      token = double(:token)
      access_token = ("a".."z").to_a.sample(10).join
      allow(token).to receive(:access_token).and_return access_token
      expect(Boxr).to receive(:get_user_token).and_return(token)
      expect(Boxr::Client).to receive(:new).with(access_token)

      user.box_client
    end
  end
end
