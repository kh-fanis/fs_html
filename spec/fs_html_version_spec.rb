require 'spec_helper'

describe FsHtml::FsHtmlVersion do
  it 'shold return html version tag' do
    expect(FsHtml::FsHtmlVersion.build(:html5)).to eql("<!DOCTYPE>")
  end
end
