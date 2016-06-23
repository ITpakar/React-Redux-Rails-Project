require 'rails_helper'

describe Document do
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
                          created_by: admin.id, deal_id: deal.id)

  }
  let(:task) {
    FactoryGirl.create(:task, section_id: section.id,
                              organization_user_id: admin.organization_user.id)
  }
  let(:document) {
        FactoryGirl.create(:document, :with_deal_document,
                              documentables: [task],
                              organization_user: admin.organization_user,
                              creator: admin.organization_user)
  }
  let(:signers) {
    [
      {
        "name" => FFaker::Name.name, "email" => FFaker::Internet.email
      },
      {
        "name" => FFaker::Name.name, "email" => FFaker::Internet.email
      }
    ]
  }
  let(:file) do
    extend ActionDispatch::TestProcess
    fixture_file_upload('test.txt', 'text/txt')
  end


  describe "#create_signers!" do
    it "creates document signers" do
      expect {
        document.create_signers!(signers)
      }.to change{document.document_signers.count}.by(2)
    end
  end

  describe "#send_to_docusign" do
    it "updates envelop_id of document signers" do
      allow(document).to receive(:upload_to_box).and_return({
        :id => 1,
        :url => FFaker::Internet.http_url,
        :download_url => FFaker::Internet.http_url
      })
      document.upload_file(file, admin.organization_user)

      allow(document).to receive(:open).and_return(true)
      client = double(:client)
      allow(DocusignRest::Client).to receive(:new).and_return(client)
      allow(client).to receive(:create_envelope_from_document).and_return({"envelopeId" => 123})

      document.create_signers!(signers)
      document.send_to_docusign
      expect(document.document_signers.map(&:envelope_id).uniq).to be_present
      expect(document.document_signers.map(&:envelope_id).uniq.length).to eql(1)
    end

    it "calls create_envelope_from_document of a DocusignRest::Client instance" do
      allow(document).to receive(:upload_to_box).and_return({
        :id => 1,
        :url => FFaker::Internet.http_url,
        :download_url => FFaker::Internet.http_url
      })
      document.upload_file(file, admin.organization_user)

      allow(document).to receive(:open).and_return(true)
      client = double(:client)
      allow(DocusignRest::Client).to receive(:new).and_return(client)
      allow(client).to receive(:create_envelope_from_document).and_return({"envelopeId" => 123})
      expect(client).to receive(:create_envelope_from_document)

      document.create_signers!(signers)
      document.send_to_docusign
    end
  end

  describe "#to_hash" do
    it "returns a hash" do
      h = document.to_hash
      expect(h).to be_kind_of(Hash)
      expect(h[:title]).to eql(document.title)
      expect(h[:signers_count]).to eql(document.document_signers.count)
    end

    it "includes user and deal documents" do
      h = document.to_hash
      expect(h[:creator]).to be_present
      expect(h[:creator][:id]).to eql(document.creator.user.id)
      expect(h[:creator][:email]).to eql(document.creator.user.email)

      expect(h[:deal_documents]).to be_kind_of(Array)
      expect(h[:deal_documents].length).to eql(document.deal_documents.count)
    end
  end

  describe "#upload_file" do
    it "uploads file and create new version" do
      allow(document).to receive(:upload_to_box).and_return({
        :id => 1,
        :url => FFaker::Internet.http_url,
        :download_url => FFaker::Internet.http_url
      })

      versions_count = {}
      document.deal_documents.each do |deal_document|
        versions_count[deal_document.id] = deal_document.versions.count
      end

      document.upload_file(file, user.organization_user)

      document.deal_documents.each do |deal_document|
        expect(deal_document.versions.count).to eql(versions_count[deal_document.id] + 1)
      end
    end
  end
end
