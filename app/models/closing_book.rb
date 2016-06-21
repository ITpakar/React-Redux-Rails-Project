require 'open-uri'
require 'rubygems'
require 'zip'

class ClosingBook < ApplicationRecord
  STATUSES = ['Unstarted', 'Processing', 'Complete']
  INDEX_TYPES = ['HTML INDEX', 'PDF INDEX', 'SINGLE PDF']

  belongs_to :deal

  has_many :closing_book_documents
  has_many :documents, through: :closing_book_documents

  before_create :delete_old_closing_book

  def delete_old_closing_book
    ClosingBook.where(deal_id: self.deal_id).destroy_all
  end

  def generate!
    base = Rails.root
    closing_book_base = Rails.public_path.to_s + '/closing_books'
    
    # Ensure the directory exists
    Dir.mkdir(closing_book_base) unless File.directory?(closing_book_base)

    # Create a temporary folder to download each file to
    files_base = closing_book_base + "/" + sanitize_filename("/#{self.deal.id}_#{self.deal.title}")
    Dir.mkdir(files_base)

    # Download each file to this folder
    self.documents.each do |document|
      file_path = files_base + "/" + sanitize_filename("#{document.id}_#{document.title}.#{document.file_type}")
      open(file_path, 'wb') do |file|
        file << open(document.to_hash[:download_url]).read
      end
    end

    self.generate_index! files_base
    url = self.generate_closing_book! files_base, closing_book_base
    self.update_attributes(url: url, status: "Complete")
    FileUtils.rm_rf(files_base)

  end

  def generate_index! file_base
    category = self.deal.closing_category.to_hash
    document_ids = self.documents.map(&:id)
    case self.index_type
      when 'HTML INDEX'
        index = ApplicationController.new.render_to_string partial: 'app/closing_books/html_index', locals: {category: self.deal.closing_category, document_ids: document_ids}, layout: false
        file_path = file_base + "/index.html"

        open(file_path, 'wb') do |file|
          file << index
        end
      when 'PDF INDEX', 'SINGLE PDF'
        pdf = WickedPdf.new.pdf_from_string(ApplicationController.new.render_to_string(partial: 'app/closing_books/html_index', locals: {category: self.deal.closing_category, document_ids: document_ids}, layout: false), {disable_internal_links: false, disable_external_links: false})
        file_path = file_base + "/index.pdf"
        
        open(file_path, 'wb') do |file|
          file << pdf
        end
    end
  end

  def generate_closing_book! files_base, closing_book_base
    case self.index_type
      when 'HTML INDEX', 'PDF INDEX'
        output_file = closing_book_base + "/" + sanitize_filename("#{self.deal.id}_#{self.deal.title}_closing_book.zip")
        zf = ZipFileGenerator.new(files_base, output_file)
        if zf.write
          return output_file
        end
        # Zip it up
      when 'SINGLE PDF'
        pdf = CombinePDF.new
        pdf << CombinePDF.load(files_base + '/index.pdf')

        self.documents.each do |document|
          file_path = files_base + "/" + sanitize_filename("#{document.id}_#{document.title}.#{document.file_type}")
          pdf << CombinePDF.load(file_path)
        end

        output_file = closing_book_base + "/" + sanitize_filename("#{self.deal.id}_#{self.deal.title}_closing_book.pdf")
        if pdf.save output_file
          return output_file
        end
    end
  end

  private
  def sanitize_filename(filename)
    return filename.gsub(/[^\w\.]/, '_')
  end
end

class ZipFileGenerator
  # Initialize with the directory to zip and the location of the output archive.
  def initialize(input_dir, output_file)
    @input_dir = input_dir
    @output_file = output_file
  end

  # Zip the input directory.
  def write
    entries = Dir.entries(@input_dir) - %w(. ..)

    ::Zip::File.open(@output_file, ::Zip::File::CREATE) do |io|
      write_entries entries, '', io
    end
  end

  private

  # A helper method to make the recursion work.
  def write_entries(entries, path, io)
    entries.each do |e|
      zip_file_path = path == '' ? e : File.join(path, e)
      disk_file_path = File.join(@input_dir, zip_file_path)
      puts "Deflating #{disk_file_path}"

      if File.directory? disk_file_path
        recursively_deflate_directory(disk_file_path, io, zip_file_path)
      else
        put_into_archive(disk_file_path, io, zip_file_path)
      end
    end
  end

  def recursively_deflate_directory(disk_file_path, io, zip_file_path)
    io.mkdir zip_file_path
    subdir = Dir.entries(disk_file_path) - %w(. ..)
    write_entries subdir, zip_file_path, io
  end

  def put_into_archive(disk_file_path, io, zip_file_path)
    io.get_output_stream(zip_file_path) do |f|
      f.puts(File.open(disk_file_path, 'rb').read)
    end
  end
end


