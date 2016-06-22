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

  describe "#generate_index!" do
    it "generate html file for HTML INDEX type" do
      html_closing_book = FactoryGirl.create(:closing_book, :deal => deal, :index_type => "HTML INDEX")
      documents = FactoryGirl.create_list(:document, rand(10), :with_deal_document,
                            documentables: [html_closing_book],
                            organization_user: admin.organization_user,
                            creator: admin.organization_user)
      path = Rails.public_path + "/closing_books"
      Dir.mkdir(path) unless File.directory?(path)
      file_path = path + "/index.html"
      File.delete(file_path) if File.exists?(file_path)
      html_closing_book.generate_index!(path)
      expect(File.exists?(file_path)).to be_truthy
    end

    it "generate pdf file for PDF INDEX type" do
      pdf_closing_book = FactoryGirl.create(:closing_book, :deal => deal, :index_type => "PDF INDEX")
      documents = FactoryGirl.create_list(:document, rand(10), :with_deal_document,
                            documentables: [pdf_closing_book],
                            organization_user: admin.organization_user,
                            creator: admin.organization_user)
      path = Rails.public_path + "/closing_books"
      Dir.mkdir(path) unless File.directory?(path)
      file_path = path + "/index.pdf"
      File.delete(file_path) if File.exists?(file_path)
      pdf_closing_book.generate_index!(path)
      expect(File.exists?(file_path)).to be_truthy
    end

    it "generate pdf file for SINGLE PDF type" do
      pdf_closing_book = FactoryGirl.create(:closing_book, :deal => deal, :index_type => "SINGLE PDF")
      documents = FactoryGirl.create_list(:document, rand(10), :with_deal_document,
                            documentables: [pdf_closing_book],
                            organization_user: admin.organization_user,
                            creator: admin.organization_user)
      path = Rails.public_path + "/closing_books"
      Dir.mkdir(path) unless File.directory?(path)
      file_path = path + "/index.pdf"
      File.delete(file_path) if File.exists?(file_path)
      pdf_closing_book.generate_index!(path)
      expect(File.exists?(file_path)).to be_truthy
    end
  end

  describe "#generate_closing_book!" do
    it "generate zip file for HTML INDEX type" do
      html_closing_book = FactoryGirl.create(:closing_book, :deal => deal, :index_type => "HTML INDEX")
      documents = FactoryGirl.create_list(:document, rand(10), :with_deal_document,
                            documentables: [html_closing_book],
                            organization_user: admin.organization_user,
                            creator: admin.organization_user)
      path = Rails.public_path + "/closing_books"
      Dir.mkdir(path) unless File.directory?(path)
      files_base = path + "/#{Time.now.to_i}"
      Dir.mkdir(files_base)
      existing_zip_files = Dir.glob(path + "/*.zip")
      html_closing_book.generate_closing_book!(files_base, path)
      all_zip_files = Dir.glob(path + "/*.zip")
      expect((all_zip_files - existing_zip_files).length).to eql(1)
      FileUtils.rm_rf(files_base)
    end

    it "generate zip file for PDF INDEX type" do
      pdf_closing_book = FactoryGirl.create(:closing_book, :deal => deal, :index_type => "PDF INDEX")
      documents = FactoryGirl.create_list(:document, rand(10), :with_deal_document,
                            documentables: [pdf_closing_book],
                            organization_user: admin.organization_user,
                            creator: admin.organization_user)
      path = Rails.public_path + "/closing_books"
      Dir.mkdir(path) unless File.directory?(path)
      files_base = path + "/#{Time.now.to_i}"
      Dir.mkdir(files_base) unless File.exists?(files_base)
      existing_zip_files = Dir.glob(path + "/*.zip")
      pdf_closing_book.generate_closing_book!(files_base, path)
      all_zip_files = Dir.glob(path + "/*.zip")
      expect((all_zip_files - existing_zip_files).length).to eql(1)
      FileUtils.rm_rf(files_base)
    end

    it "generate PDF file for SINGLE PDF type" do
      pdf_closing_book = FactoryGirl.create(:closing_book, :deal => deal, :index_type => "SINGLE PDF")
      documents = FactoryGirl.create_list(:document, rand(10), :with_deal_document,
                            documentables: [pdf_closing_book],
                            organization_user: admin.organization_user,
                            creator: admin.organization_user)
      path = Rails.public_path + "/closing_books"
      Dir.mkdir(path) unless File.directory?(path)

      file_path = path + "/index.pdf"
      File.delete(file_path) if File.exists?(file_path)
      pdf_closing_book.generate_index!(path)

      files_base = path + "/#{Time.now.to_i}"
      Dir.mkdir(files_base) unless File.exists?(files_base)
      existing_pdf_files = Dir.glob(path + "/*.pdf")
      pdf_closing_book.generate_closing_book!(files_base, path)
      all_pdf_files = Dir.glob(path + "/*.pdf")
      expect((all_pdf_files - existing_pdf_files).length).to eql(1)
      FileUtils.rm_rf(files_base)
    end
  end

  describe "#generate!" do
    let(:documents) {
      FactoryGirl.create_list(:document, rand(10), :with_deal_document,
                          documentables: [closing_book],
                          organization_user: admin.organization_user,
                          creator: admin.organization_user)
    }

    it "generate closing book" do
      allow(closing_book).to receive(:generate_closing_book!).and_return("#{Rails.public_path}/closing_books/whaever")
      expect(closing_book).to receive(:generate_closing_book!)
      documents
      closing_book.generate!
    end

    it "updates url and mark status as complete" do
      documents
      expect(closing_book.url).to be_blank
      closing_book.generate!
      closing_book.reload
      expect(closing_book.status).to eql("Complete")
      expect(closing_book.url).to be_present
    end
  end
end
