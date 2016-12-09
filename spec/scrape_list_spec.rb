require 'spec_helper'
require 'uri'

STUB_URL = 'http://www.example.com/'

describe ScrapeList do
  it 'has a version number' do
    expect(ScrapeList::VERSION).not_to be nil
  end

  def load_stub(url, file)
    stub_html = "#{File.dirname(__FILE__)}/stub/#{file}"
    stub_request(:get, url)
      .to_return(status: 200, body: File.new(stub_html), :headers => {content_type: 'text/html'})
  end

  it 'requests url' do
    load_stub(STUB_URL, 'example1.html')
    rule = ScrapeList::Rule.new
    rule.url_rule = %r{/link}
    rule.list_rule = 'div.list'
    rule.item_rule = 'div.item'
    result = ScrapeList.request(STUB_URL, rule)
    expect(result.is_a?(Hash)).to eq(true)
    expect(result.key?(:links)).to eq(true)
    expect(result.key?(:items)).to eq(true)
  end

  it 'requests links' do
    load_stub(STUB_URL, 'example1.html')
    1.upto(10) { |num| load_stub("#{STUB_URL}link/#{num}", 'example2.html') }
    base_url = URI.parse(STUB_URL)
    rule = ScrapeList::Rule.new
    rule.url_rule = %r{/link/}
    rule.list_rule = 'div.list'
    rule.item_rule = 'div.item'
    result = ScrapeList.request('http://www.example.com/', rule)
    result[:links].each do |link|
      rule = ScrapeList::Rule.new
      rule.list_rule = 'div.list-second'
      rule.item_rule = 'div.item-second'
      url = link.href.match(/^http/) ? link.href : "#{base_url.scheme}://#{base_url.host}#{link.href}"
      result = ScrapeList.request(url, rule)
      expect(result.is_a?(Hash)).to eq(true)
      expect(result.key?(:links)).to eq(true)
      expect(result.key?(:items)).to eq(true)
    end
  end
end
