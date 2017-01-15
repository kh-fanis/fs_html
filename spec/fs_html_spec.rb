require 'spec_helper'

describe FsHtml do
  it 'should rightly build html version tag' do
    html = FsHtml.new(:html5)
    expect(html.html_version).to eql("<!DOCTYPE>")
  end

  it 'should build basic html page' do
    html = FsHtml.new(:html5)

    expect(html.build).to eql("<!DOCTYPE><html><head></head><body></body></html>")
  end

  it 'should build html file passing block' do
    html = FsHtml.new(:html5)

    html.title = "Hello World"

    html.append do |content|
        content.h1 "Hello World"
    end

    expect(html.build).to eql("<!DOCTYPE><html><head><title>Hello World</title></head><body><h1>Hello World</h1></body></html>")
  end

  it 'should create html page passing block to initializer' do
    html = FsHtml.new do |h|
      h.title = "Hello World"

      h.css do |append|
        append.h1({ 'font-size': 14 })
      end

      h.content do |append|
        append.h1 "hello world"
      end
    end

    expect(html.build).to eql('<!DOCTYPE><html><head><title>Hello World</title><style>h1 {font-size:14px}</style></head><body><h1>hello world</h1></body></html>')
  end

  context '#add_style_link' do
    it 'should add style links to html' do
      html = FsHtml.new do |html|
        html.add_style_link('style.css')
      end
    end
  end
end
