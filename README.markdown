# universe
## lifestreaming made simple

universe (and Yahoo! Pipes) make it super simple to create a lifestream of yourself, your company, or whatever!

### Setup

1. You'll need to create a Yahoo! Pipe to combine all your feeds into one RSS feed.  You can see ours here: http://pipes.yahoo.com/pipes/pipe.info?_id=6b733facbd35af0391add092723f6565

2. Once you have your Pipe rolling, then you need to come back to universe.rb and edit the SOURCE_MAP constant to match your data (mostly just the blog URL matcher unless you've added more feeds).  

3. Run it!

### TODO

1. Caching.  Right now we fetch the feed on each request.  It's slow and I'm sure Yahoo! wouldn't be very happy if a universe instance got vaguely popular.
2. Finish custom data formatters.  The Twitter one is getting there, but it'd be nice to have nicer formatting for Github and Tumblr, too.
3. Maybe add a few more sources...