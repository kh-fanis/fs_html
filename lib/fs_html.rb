require 'fs_html/fs_html_version'
require 'fs_html/fs_html_tag'
require 'fs_html/fs_css'
require 'fs_html/version'

class FsHtml
  attr_accessor :version, :title
  attr_reader :content, :css, :style_links

  def initialize (version = :html5)
    _set_deafults
    @version = version

    yield self if block_given?
  end

  # Html Content Operations

  def append (&block)
    @content.append(&block)
  end

  def append_css (&block)
    @css.append(&block)
  end

  def add_style_link (file_name)
    style_links << file_name
  end

  # Builders

  def html_version
    FsHtmlVersion::build(@version)
  end

  def build
    "#{html_version}<html><head>#{build_title}#{build_css}</head>#{content.build}</html>"
  end

  def build_title
    FsHtmlTag.new(:title, @title).build if @title
  end

  def build_css
    FsHtmlTag.new(:style, css.build).build unless css.empty?
  end

  def build_style_links
    style_links.map { |str| FsHtmlTag.new(:link) }
  end

  # Redefining Readers

  def content (&block)
    if block_given?
      reset_content
      append &block
    else
      @content
    end
  end

  def css (&block)
    if block_given?
      reset_css
      append_css &block
    else
      @css
    end
  end

  # Resetters

  def reset_css
    @css = _default_css_value
  end

  def reset_content
    @content = _default_content_value
  end

  def reset_style_links
    @style_links = _default_style_links_value
  end

private

  # Defatuls

  def _set_deafults
    reset_content
    reset_css
    reset_style_links
  end

  def _default_css_value
    FsCss.new
  end

  def _default_content_value
    FsHtmlTag.new(:body)
  end

  def _default_style_links_value
    Array.new
  end
end
