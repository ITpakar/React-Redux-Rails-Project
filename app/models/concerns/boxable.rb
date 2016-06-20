module Boxable
  extend ActiveSupport::Concern
  
  # Get Enterprise Box Client
  def box_enterprise_client
    if Rails.env.development?
      private_key = ENV['JWT_PRIVATE_KEY']
    else
      private_key = OpenSSL::PKey::RSA.new(YAML.load(%Q(---\n"#{ENV['JWT_PRIVATE_KEY']}"\n)), ENV['JWT_PRIVATE_KEY_PASSWORD'])
    end
    # Get Box enterprise token
    token = Boxr::get_enterprise_token(private_key: private_key)

    # Get Box enterprise client
    Boxr::Client.new(token.access_token)
  end

  # Get Box Client
  def box_user_client(box_user_id)
    if Rails.env.development?
      private_key = ENV['JWT_PRIVATE_KEY']
    else
      private_key = YAML.load(%Q(---\n"#{ENV['JWT_PRIVATE_KEY']}"\n))
    end
    token = Boxr::get_user_token(box_user_id.to_s, private_key: private_key, private_key_password: ENV['JWT_PRIVATE_KEY_PASSWORD'])
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