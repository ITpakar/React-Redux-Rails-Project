Swagger::Docs::Config.register_apis({
  "1.0" => {
    # the extension used for the API
    :api_extension_type => :json,
    # the output location where your .json files are written to
    :api_file_path => "public/swagger_api",
    # the URL base path to your API
    :base_path => "http://localhost:3000",
    :attributes => {
      :info => {
        "title" => "Doxly",
        "description" => "This is Doxly"
      }
    }
  }
})

class Swagger::Docs::Config
  def self.transform_path(path, api_version)
    "swagger_api/#{path}"
  end
end