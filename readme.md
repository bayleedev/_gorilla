## GO-REE-LUHZ
Solution based on a [programming challenge](https://gist.github.com/samg/5b287544800f8a6cddf2) I stumbled upon.

There is a compiled version of `/src/*.rb` in `/solution.rb` because I realized how slow ruby was to open a few files. Like really slow.

## Usage
Pulled directly from the challege I linked to from above.
~~~
$ -> COUNT_CALLS_TO='String#size' ruby -r ./solution.rb -e '(1..100).each{|i| i.to_s.size if i.odd? }'
String#size called 50 times

$ -> COUNT_CALLS_TO='B#foo' ruby -r ./solution.rb -e 'module A; def foo; end; end; class B; include A; end; 10.times{B.new.foo}'
B#foo called 10 times
~~~

## Testing
Testing using rspec, because because.
~~~
bundle install
rspec
~~~
