require 'spec_helper'

describe ScrapeList do
  it 'has a version number' do
    expect(ScrapeList::VERSION).not_to be nil
  end

  it 'requests url' do
    rule = ScrapeList::Rule.new
    rule.url_rule = %r{/_ylt}
    rule.list_rule = 'div.topicsindex ul.emphasis'
    rule.item_rule = 'li'
    result = ScrapeList.request('http://www.yahoo.co.jp/', rule)
    expect(result.is_a?(Hash)).to eq(true)
    expect(result.key?(:links)).to eq(true)
    expect(result.key?(:items)).to eq(true)
  end

  it 'requests links' do
    rule = ScrapeList::Rule.new
    rule.url_rule = %r{/pickup}
    rule.list_rule = 'div.topicsindex ul.emphasis'
    rule.item_rule = 'li'
    result = ScrapeList.request('http://www.yahoo.co.jp/', rule)
    result[:links].each do |link|
      rule = ScrapeList::Rule.new
      rule.list_rule = 'div.subRanking ol li'
      rule.item_rule = 'span.ttl'
      result = ScrapeList.request(link.href, rule)
      expect(result.is_a?(Hash)).to eq(true)
      expect(result.key?(:links)).to eq(true)
      expect(result.key?(:items)).to eq(true)
    end
  end
end
