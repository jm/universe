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
    text = text.split(/: /)[1]
    
    # link @username
    if text =~ /@(\S)*/
      text.gsub!(/@(\S)*/, "<a href='http://twitter.com/#{Regexp::last_match[0].delete("@")}'>#{Regexp::last_match[0]}</a>")
    end
    
    text
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