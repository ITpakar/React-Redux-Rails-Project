class AssetManifest

  MANIFEST_FILE = "rev-manifest.json"

  class << self

    def manifest
      @manifest ||= read_manifest(manifest_file_path)
    end

    def stylesheet_path(url)
      url += ".css" unless url.end_with?(".css")
      AssetManifest.manifest["stylesheets/" + url] || url
    end

    def javascript_path(url)
      url += ".js" unless url.end_with?(".js")
      AssetManifest.manifest["javascripts/"+url] || url
    end

    def asset_path(url)
      AssetManifest.manifest["images/"+url] || url
    end

    private

    def manifest_file_path
      File.join(Rails.root, "public", MANIFEST_FILE)
    end

    def read_manifest(path)
      if File.exists?(path)
        JSON.parse(File.read(manifest_file_path))
      else
        {}
      end
    end

  end
end
