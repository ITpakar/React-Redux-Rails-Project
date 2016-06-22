class App::DealsController < App::ApplicationController
  before_filter :authenticate_user!
  before_action :set_deal, only: [:show, :diligence, :closing, :closing_book, :create_closing_book]

  before_action only: [:show, :diligence, :closing, :closing_book] do
    authorize! :read, @deal
  end

  layout 'deals', only: [:show, :diligence, :closing, :closing_book]

  def index
    @deals = format_deals_for_display(current_user.context.deals.uniq)
  end

  def show
  end

  def diligence
  end

  def closing
  end

  def create_closing_book
    @closing_book = ClosingBook.create(deal_id: @deal.id, status: 'Processing', index_type: params[:format])
    params['selectedDocuments'].each do |document_id|
      ClosingBookDocument.create(document_id: document_id, closing_book_id: @closing_book.id)
    end

    if @closing_book.persisted?
      # This will be handled asynchronously
      @closing_book.generate!
      render json: {closing_book: @closing_book}, status: :ok
    else
      render json: {errors: @closing_book.errors}, status: :unprocessable_entity
    end
  end

  def closing_book
    category = @deal.closing_category
    sections = category.sections.order("name ASC")

    results = []

    sections.each do |section|
      tasks = []
      section_h = {}
      section_h[:id] = section.id
      section_h[:type] = section.class.name
      section_h[:title] = section.name
      section_h[:elements] = tasks

      section.tasks.order("title").each do |task|
        task_elements = []
        task_h = {}
        task_h[:id] = task.id
        task_h[:type] = task.class.name
        task_h[:title] = task.title
        task_h[:elements] = task_elements

        task.documents.select("DISTINCT documents.*").order("title").each do |document|
          document_h = document.to_hash
          document_h[:id] = document.id
          document_h[:type] = document.class.name
          task_elements << document_h
        end

        task.folders.order("name").each do |folder|
          folder_elements = []
          folder_h = {}
          folder_h[:id] = folder.id
          folder_h[:type] = folder.class.name
          folder_h[:title] = folder.name
          folder_h[:elements] = folder_elements

          folder.documents.select("DISTINCT documents.*").order("title").each do |document|
            document_h = document.to_hash
            document_h[:id] = document.id
            document_h[:type] = document.class.name
            folder_elements << document_h
          end

          task_elements << folder_h
        end

        tasks << task_h
      end

      results << section_h
    end

    @category = results

    @closing_book = @deal.closing_book
  end

  private

  def set_deal
    @deal = current_organization.deals.find(params[:id])
  end

  # This method will add the collaborators attribute, the starred attribute
  # and will group the deals together
  def format_deals_for_display deals
    deals = deals.map {|deal| deal.attributes.merge({
      collaborators: deal.organization_users.map{|org_user| org_user.attributes.merge({avatar: org_user.user.avatar.url, initials: org_user.user.initials})}, 
      starred: deal.starred_deals.where(organization_user_id: current_user.organization_user.id).present? })}
    
    grouped = deals.group_by {|deal| DateTime.parse(deal["projected_close_date"].to_s).strftime("%B %Y")}

    grouped.keys.map {|key| {heading: key, deals: grouped[key]}}
  end
end