require 'rails_helper'

describe Notification do
  let(:owner) {FactoryGirl.create(:owner, :with_confirmed_email)}
  let(:organization) { FactoryGirl.create(:organization, :created_by => owner.id)}
  let(:user) {
    FactoryGirl.create(:user, :with_organization_user, :with_confirmed_email,
                              :organization_id => organization.id)
  }
  let(:notification) {Notification.create!(:organization_user => user.organization_user,
                                            :message => FFaker::Lorem.sentences.join(". "))}

  describe "#to_hash" do
    it "returns a hash" do
      h = notification.to_hash
      expect(h).to be_kind_of(Hash)
      expect(h[:message]).to eql(notification.message)
    end

    it "includes creator" do
      h = notification.to_hash
      expect(h[:user]).to be_present
      expect(h[:user][:id]).to eql(user.id)
      expect(h[:user][:email]).to eql(user.email)
    end
  end
end
