module BoxStorable
  extend ActiveSupport::Concern
  
  # Get Enterprise Box Client
  def box_enterprise_client
    # Get Box enterprise token
    token = Boxr::get_enterprise_token

    # Get Box enterprise client
    Boxr::Client.new(token.access_token)
  end

  # Get Box Client
  def box_user_client(box_user_id)
    token = Boxr::get_user_token(box_user_id.to_s)
    Boxr::Client.new(token.access_token)
  end

  def create_box_user(name)
    client = box_enterprise_client
    client.create_user(name, is_platform_access_only: true)
  end
  
  def box_client
    unless self.box_user_id
      user = create_box_user(self.to_s)
      self.update(box_user_id: user[:id])
    end
    box_user_client(self.box_user_id)
  end
end