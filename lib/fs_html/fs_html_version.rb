require 'fs_html'

class FsHtml
  module FsHtmlVersion

    def self.build (html_version)

      case html_version
        when :html5
          "<!DOCTYPE>"
      end

    end

  end
end
