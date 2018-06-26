# BreezyPDFLite

[![Build Status](https://travis-ci.org/danielwestendorf/breezy_pdf_lite-ruby.svg?branch=master)](https://travis-ci.org/danielwestendorf/breezy_pdf_lite-ruby)
[![Gem Version](https://badge.fury.io/rb/breezy_pdf_lite.svg)](https://badge.fury.io/rb/breezy_pdf_lite)

A ruby client for [BreezyPDFLite](https://github.com/danielwestendorf/breezy-pdf-lite), a one-click-to-deploy microservice for converting HTML to PDF with Google Chrome. Send the library a chunk of HTML, get a PDF of it back. Configure how the PDF is rendered via [`meta` tags](https://github.com/danielwestendorf/breezy-pdf-lite#2-configure-with-meta-tags-optional) in the HTML.

Use pragmatically, or as a Rack Middleware.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'breezy_pdf_lite'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install breezy_pdf_lite

## Usage

BreezyPDFLite requires some configuration before you can use it. Somewhere in your application (perhaps in `config/intializers/breezy_pdf_lite.rb`), configure the `base_url`and the `secret_api_key` of your service. Get these from your Heroku configuration.

```ruby
BreezyPDFLite.setup do |config|
  config.secret_api_key = ENV["BREEZYPDF_SECRET_API_KEY"]
  config.base_url = ENV.fetch("BREEZYPDF_BASE_URL", "http://localhost:5001")
end
```

### Middleware

Add the Middleware to your stack.

_Ruby on Rails_
```ruby
# config/application.rb
config.middleware.use BreezyPDFLite::Middleware
```

Any URL ending in `.pdf` will be intercepted, rendered as HTML, rendered to a PDF, and then returned to the client.

_Rack/Sinatra/etc_

See `example/config.ru`

### Pragmatic

See `example/pragmatic.rb`


## Examples
Examples depend on the [BreezyPDFLite](https://github.com/danielwestendorf/breezy-pdf-lite) microservice being avialable.

_Middleware_

`BREEZYPDF_SECRET_API_KEY=YOURSECRETKEY BREEZYPDF_BASE_URL=https://YOURHEROKUAPPORWHATEVER.herokuapp.com/ rackup example/config.ru`

Visit `https://localhost:9292` and click the link to download the PDF.

_Pragmatic_

`BREEZYPDF_SECRET_API_KEY=YOURSECRETKEY BREEZYPDF_BASE_URL=https://YOURHEROKUAPPORWHATEVER.herokuapp.com/ ruby example/pragmatic.rb`

The PDF will be downloaded to `example/example.pdf`

## License

See `LICENSE.txt`.
