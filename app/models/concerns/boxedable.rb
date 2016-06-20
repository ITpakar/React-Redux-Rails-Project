module Boxedable
  extend ActiveSupport::Concern

  def upload_to_box(local_path, folders, boxable)
    client = boxable.box_client
    path = '/'
    parent = client.folder_from_path(path)
    folders.each do |folder|
      box_folder = client.folder_items(parent).folders.select{|i| i.name == folder}.first
      if box_folder.nil?
        box_folder = client.create_folder(folder, parent)
      end
      parent = box_folder
    end
    
    box_file = client.upload_file(local_path, parent)
    updated_file = client.create_shared_link_for_file(box_file, access: :open, can_download: true, can_preview: true)

    ret = {
      :id => box_file.id,
      :url => updated_file.shared_link.url, # client.preview_url(box_file)
      :download_url => updated_file.shared_link.download_url # client.download_url(box_file)
    }
  end
end