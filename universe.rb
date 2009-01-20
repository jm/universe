require 'rubygems'
require 'rss'
require 'open-uri'

require 'sinatra'

SOURCE_MAP = {
  /twitter.com/     => 'twitter',
  /github.com/      => 'github',
  /hoth.entp.com/   => 'blog', 
  /tumblr.com/      => 'tumblr'
}

helpers do
  def partial(page, options={})
    erb page, options.merge!(:layout => false)
  end
  
  def entry(item, template)
    partial(template.to_sym, :locals => {:item => item})
  end
  
  def find_source_of(item)
    SOURCE_MAP.each do |matcher, template|
      if item.link =~ matcher
        return template
      end
    end
  end
  
  def twitter_format(text)
    # cut off the username
    text = text.sub(/^(.*?:)/, '')
    
    text = auto_link(text)
    
    # link @username
    if text =~ /@(\S)*/
      text.gsub!(/@(\S)*/, "<a href='http://twitter.com/#{Regexp::last_match[0].delete("@")}'>#{Regexp::last_match[0]}</a>")
    end    
    
    text
  end
  
  # Jacked from ActiveSupport
  AUTO_LINK_RE = %r{
      ( https?:// | www\. )
      [^\s<]+
    }x unless const_defined?(:AUTO_LINK_RE)
    
  def auto_link(text)
    text.gsub(AUTO_LINK_RE) do
      href = $&
      punctuation = ''
      # detect already linked URLs
      if $` =~ /<a\s[^>]*href="$/
        # do not change string; URL is alreay linked
        href
      else
        # don't include trailing punctuation character as part of the URL
        if href.sub!(/[^\w\/-]$/, '') and punctuation = $& and opening = BRACKETS[punctuation]
          if href.scan(opening).size > href.scan(punctuation).size
            href << punctuation
            punctuation = ''
          end
        end

        link_text = href
        href = 'http://' + href unless href.index('http') == 0

        "<a href='#{href}'>#{link_text}</a>" + punctuation
      end
    end
  end
end

get '/' do
  @feed = fetch_rss_feed
  
  erb :index
end

def fetch_rss_feed
  source = "http://pipes.yahoo.com/pipes/pipe.run?_id=6b733facbd35af0391add092723f6565&_render=rss"

  rss = RSS::Parser.parse open(source)
end