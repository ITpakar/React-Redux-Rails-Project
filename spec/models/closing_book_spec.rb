require 'rails_helper'

describe ClosingBook do
  let(:owner) {FactoryGirl.create(:owner, :with_confirmed_email)}
  let(:organization) { FactoryGirl.create(:organization, :created_by => owner.id)}
  let(:admin) {
    FactoryGirl.create(:user, :with_organization_admin_user, :with_confirmed_email,
                              :organization_id => organization.id)
  }
  let(:deal) {FactoryGirl.create(:deal, :organization => organization, :organization_user => admin.organization_user)}
  let(:closing_book) {FactoryGirl.create(:closing_book, :deal => deal)}

  context "callbacks" do
    it "destroy deal's closing book before create" do
      closing_book
      FactoryGirl.create(:closing_book, :deal => deal)
      expect(ClosingBook.where(:id => closing_book.id).count).to eql(0)
    end
  end

  describe "#delete_old_closing_book" do
    it "delete deal's closing book" do
      closing_book
      expect{
        ClosingBook.new(:deal => deal).delete_old_closing_book
      }.to change{ClosingBook.count}.by(-1)
    end

    it "does not delete other deal's closing books" do
      other_deal = FactoryGirl.create(:deal, :organization => organization, :organization_user => admin.organization_user)
      other_deal_closing_book = FactoryGirl.create(:closing_book, :deal => other_deal)
      closing_book

      ClosingBook.new(:deal => deal).delete_old_closing_book
      expect(other_deal.closing_book.reload).to be_present
    end
  end
end
