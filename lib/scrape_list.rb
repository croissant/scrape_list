require 'scrape_list/version'
require 'mechanize'
require 'active_support/dependencies'

# ScrapeList module.
module ScrapeList
  # Your code goes here...
  autoload :Rule, 'scrape_list/rule'
  class << self
    # request url and parse with rules
    # @param [String] url
    # @param [Rule] rule
    # @return [Hash]
    def request(url, rule)
      agent = ::Mechanize.new
      page = agent.get(url)
      links = rule.url_rule.nil? ? [] : page.links.select { |link| link.href.match(rule.url_rule) }
      items = page.search(rule.list_rule).search(rule.item_rule)
      {
        links: links,
        items: items,
      }
    end
  end
end
