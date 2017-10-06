# Naver Blog Crawler

* README:       https://github.com/Thecatdog/supermom2
* Bug Reports:  https://github.com/Thecatdog/supermom2/issues


## Description

Naver Blog Crawler is an HTML parser for Naver Blog. Naver Blog Cralwer is based on Nokogiri and Mechanize.
Nokogiri's features is the ability to search documents via XPath or CSS3 selectors. and Mechanize's feature is for following links and submit forms.

## Features

* XML/HTML DOM parser which handles broken HTML
* XML/HTML SAX parser
* XML/HTML Push parser
* XPath 1.0 support for document searching
* CSS3 selector support for document searching
* XML/HTML builder
* XSLT transformer



## Installation


## Support




__WARNING__

Some documents declare one encoding, but actually use a different
one. In these cases, which encoding should the parser choose?

Data is just a stream of bytes. Humans add meaning to that stream. Any
particular set of bytes could be valid characters in multiple
encodings, so detecting encoding with 100% accuracy is not
possible. `libxml2` does its best, but it can't be right all the time.

If you want Nokogiri to handle the document encoding properly, your
best bet is to explicitly set the encoding.  Here is an example of
explicitly setting the encoding to EUC-JP on the parser:

```ruby
  doc = Nokogiri.XML('<foo><bar /><foo>', nil, 'EUC-JP')
```

## Development


## License


