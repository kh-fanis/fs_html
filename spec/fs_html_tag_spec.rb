require 'spec_helper'

describe FsHtml::FsHtmlTag do
  it 'should return basic text tag' do
    html_tag = FsHtml::FsHtmlTag.new :p, "Hello World"

    expect(html_tag.build).to eql("<p>Hello World</p>")
  end

  it 'should append nested tag inside' do
    html_tag = FsHtml::FsHtmlTag.new

    html_tag.append do |h|
      h.p "Hello World"
    end

    expect(html_tag.build).to eql("<div><p>Hello World</p></div>")
  end

  it 'should append nested tag inside (example #2)' do
    html_tag = FsHtml::FsHtmlTag.new

    html_tag.append do |h|
      h.p "Hello World"
      h.div "adsf" do |d|
        d.p "hello"
      end
    end

    expect(html_tag.build).to eql("<div><p>Hello World</p><div><p>hello</p></div></div>")
  end

  context '#build_attributes' do
    it 'should return attributes' do
      html_tag = FsHtml::FsHtmlTag.new(:input, {value: 'Click On Me', type: :button})

      # First Version
      expect(html_tag.build).to eql('<input value="Click On Me" type="button"></input>')
      # Second Version
      html_tag.is_line_tag = true
      expect(html_tag.build).to eql('<input value="Click On Me" type="button"/>')
    end

    context '(tag\'s styles)' do
      it 'should add style as attribute passing Css Object' do
        html_tag = FsHtml::FsHtmlTag.new(:p, "Hello World", {style: FsHtml::FsCss.new({'font-color' => 'red'}), hidden: true})

        expect(html_tag.build).to eql('<p style="font-color:red" hidden="true">Hello World</p>')
      end

      it 'should add style as attribute passing Hash' do
        html_tag = FsHtml::FsHtmlTag.new(:p, "Hello World", {style: {'font-color' => 'red'}, hidden: true})

        expect(html_tag.build).to eql('<p style="font-color:red" hidden="true">Hello World</p>')
      end
    end
  end

  it 'should build nested html tag passing block' do
    html_tag = FsHtml::FsHtmlTag.new(:div, {id: :main_div, style: {'font-color': 'red'}}) do |main_div|
      main_div.h1 "Main Block"
      main_div.ul(id: :main_menu, class: :menu) do |menu|
        menu.li "First Link"
        menu.li "Second Link"
        menu.li "Third Link"
      end
    end

    expect(html_tag.build).to eql('<div id="main_div" style="font-color:red"><h1>Main Block</h1><ul id="main_menu" class="menu"><li>First Link</li><li>Second Link</li><li>Third Link</li></ul></div>')
  end
end
