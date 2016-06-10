class App::HomeController < App::ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def deals
  end

  def deal
  end

  def team
  end

  def team_item
  end

  def deal_client
  end

  def deal_file
    # client = current_user.box_client

    # client.delete_file(client.file_from_path('/.gitignore'))
    # folder = client.folder_from_path('/')
    # file = client.upload_file('.gitignore', folder)
    # updated_file = client.create_shared_link_for_file(file, access: :open)
    # puts "Shared Link: #{updated_file.shared_link.url}"

    # items = client.root_folder_items
    # items.each {|i| puts i.name}
    
    # Delete all app users on box
    # client = User.enterprise_box_client
    # client.all_users.each do |user|
    #   client.delete_user(user)
    # end
  end

  def report
  end

  def setting
  end

  def signin
  end

  def signup
  end
end