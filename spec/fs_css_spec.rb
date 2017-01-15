require 'spec_helper'

describe FsHtml::FsCss do
  it 'should return sample style' do
    stylesheet = FsHtml::FsCss.new({ 'font-color' => 'red', 'color' => 'black' })
    expect(stylesheet.build).to eql('font-color:red;color:black')
  end

  it 'should return basic stylesheet' do
    stylesheet = FsHtml::FsCss.new(:p, { 'font-color' => 'red', 'color' => 'black' })

    expect(stylesheet.build).to eql('p {font-color:red;color:black}')
  end

  it 'should return nested stylesheet' do
    stylesheet = FsHtml::FsCss.new(:p, { 'font-color' => 'red', 'color' => 'black' }) do |s|
      s.a({ 'color' => 'yellow' })
    end

    expect(stylesheet.build).to eql('p {font-color:red;color:black}p a {color:yellow}')
  end

  it 'should return empty css design' do
    stylesheet = FsHtml::FsCss.new
    expect(stylesheet.build).to eql('')
  end

  it 'should return stylesheet' do
    stylesheet = FsHtml::FsCss.new do |s|
      s.p({ 'font-size' => 12 }) do |p|
        p.a({ 'font-size' => 11, 'backgroun-color' => :red }) do |a|
          a.button({ 'backgroun-color' => 'green' }) do |b|
            b.span({ 'color' => 'red' })
          end
        end
      end
    end

    expect(stylesheet.build).to eql('p {font-size:12px} p a {font-size:11px;backgroun-color:red} p a button {backgroun-color:green} p a button span {color:red}')
  end
end
