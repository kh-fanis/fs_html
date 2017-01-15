require 'fs_html'

class FsHtml
  class FsCss
    attr_accessor :name, :parent
    attr_reader :children, :design

    def initialize (name = nil, design = nil, parent = nil, html_tags_allowed = false, &block)
      _set_deafults

      if name.kind_of?(String) || name.kind_of?(Symbol)
        @name, @design, @parent = name, design, parent
      elsif name.kind_of? Hash
        @design, @parent = name, design
      end

      append &block if block_given?
    end

    def append
      yield self if block_given?
    end

    def build
      if @name
        "#{_build_name_with(@parent)}#{_build_name}{#{build_design}}"
      else
        build_design
      end + build_children
    end

    def build_design
      @design.map { |k, v| "#{k}:#{v.kind_of?(Integer) ? "#{v}px" : v}" }.join(";")
    end

    def build_children
      @children.map { |child| "#{child.build}" }.join(" ")
    end

    def method_missing (name, *args, &block)
      super unless caller_locations(1, 1).first.label != 'append'  && _append(name, *args, &block)
    end

    def empty?
      @children.empty? && @design.empty?
    end

  private

    def _append (name, *args, &block)
      parent = [@parent, @name].compact.join(" ")
      @children << FsCss.new(name, args[0], parent, &block)
    end

    def _build_name
      _build_name_with(@name)
    end

    def _build_name_with (name)
      unless name.nil? || name == ""
        "#{name} "
      else
        ""
      end
    end

    # Defaults

    def _set_deafults
        @children, @design = [], Hash.new
    end
  end
end
