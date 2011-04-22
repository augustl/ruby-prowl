# Prowl

Ruby wrapper for [Prowl](http://www.prowlapp.com/).

## About
 
Prowl rocks! It's a webapp and a iPhone app that works  
together and lets you send push notifications via HTTP  
to any iPhone that has the prowl app installed.  

```` ruby
Prowl.add(
  :apikey => "api key abc123def456",
  :application => "World Saving Project Manager",
  :event => "Canceled",
  :description => "It sucked, so I canceled it. Sorry :("
)
````

The user has given you its API key. That lets you  
send push notifications to the users iPhone, through  
the Prowl iPhone app.  

## Installation
 
    gem install prowl
    
Code available [here](http://github.com/augustl/ruby-prowl/tree).
 
## Notice

`Prowl.send` has been renamed to `Prowl.add`.

## Usage
  
Four required parameters:
    
- *apikey* (String / Array< String >)
- *application* (String)
- *event* (String)
- *description* (String)
    
You can use `Prowl.add`, or create instances of Prowl manually.

```` ruby
Prowl.add(:apikey => "123abc", :application => "Foo", ...)
Prowl.verify("apikey")

p = Prowl.new(:apikey => "apikey123abc", :application => "FooApp")
p.valid?
p.add(:event => "It's valid", ...)
````

## Authors

- [August Lilleaas](http://august.lilleaas.net/).