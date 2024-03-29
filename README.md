NOTE: This is not actively maintained! It can contain both bugs and security issues simply by being old code that has not been kept up to date.

# SessionTracker

Track active users sessions in redis.

## Installation

Add this line to your application's Gemfile:

    gem 'session_tracker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install session_tracker

## Usage

In your ApplicationController:

    before_filter :track_active_sessions

    def track_active_sessions
      SessionTracker.new("user", $redis).track(session[:session_id])
    end

Then to view the current state:

    SessionTracker.new("user", $redis).active_users

If redis is accessible through $redis, you don't have to give it as an argument to SessionTracker.new.

Read the spec and/or code to see how it works.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits and license

Inspired by [http://www.lukemelia.com/blog/archives/2010/01/17/redis-in-practice-whos-online/](http://www.lukemelia.com/blog/archives/2010/01/17/redis-in-practice-whos-online/).

By [Joakim Kolsjö](https://github.com/joakimk) under the MIT license:

>  Copyright (c) 2012 Joakim Kolsjö
>
>  Permission is hereby granted, free of charge, to any person obtaining a copy
>  of this software and associated documentation files (the "Software"), to deal
>  in the Software without restriction, including without limitation the rights
>  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>  copies of the Software, and to permit persons to whom the Software is
>  furnished to do so, subject to the following conditions:
>
>  The above copyright notice and this permission notice shall be included in
>  all copies or substantial portions of the Software.
>
>  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>  THE SOFTWARE.
