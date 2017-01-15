require 'fs_html'

class FsHtml
  class FsHtmlTag
    attr_accessor :name, :content, :is_line_tag
    attr_reader :children, :attributes

    def initialize name = "div", content = nil, attributes = Hash.new(""), is_line_tag = false, &block
      _set_deafults

      @name,  = name, is_line_tag

      if content.kind_of?(Hash)
        @attributes   = content
        @is_line_tag  = attributes.kind_of?(Hash) ? false : attributes
      else
        @attributes   = attributes
        @is_line_tag  = is_line_tag
      end

      unless block_given?
        @content = content unless content.kind_of?(Hash)
      else
        append(&block)
      end
    end

    # Html Tag Operations

    def append &block
      yield(self)
    end

    # Builders

    def build
      if @is_line_tag
        "<#{name}#{build_attributes}/>"
      else
        "<#{name}#{build_attributes}>#{content}#{children.map(&:build).join("")}</#{name}>"
      end
    end

    def build_attributes
      result = @attributes.map do |attribute, value|
        if attribute == :style || attribute == 'style'
          value   = value.build           if value.kind_of? FsCss
          value   = FsCss.new(value).build  if value.kind_of? Hash
        end

        "#{attribute}=\"#{value}\""
      end.join(" ")

      result  = " " + result unless result == ""
      result
    end

    # Method Missing

    def method_missing (name, *args, &block)
      super unless caller_locations(1, 1).first.label != 'append' && _append(name, *args, &block)
    end

    # Resetters

    def _reset_children
      @children = _default_children_value
    end

  private

    def _append (name, *args, &block)
      @children << FsHtmlTag.new(name, *args, &block)
    end

    # Defaults

    def _set_deafults
      _reset_children
    end

    def _default_children_value
      []
    end
  end
end
