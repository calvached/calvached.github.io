---
layout: post
title: "Exploring the lands of Public and Private interfaces"
date: 2014-06-15 15:44:22 -0500
comments: true
categories: [tech, POODR]
---

Let's talk about interfaces (and possibly spaghetti)!!

Interface can mean a bunch of things in different contexts, but in this post I'll be referring to it as anything that is contained within a Class.
<!-- more -->
Lately, I've been reading Sandy Metz's book, Practical Object Oriented Design in Ruby (affectionately called "POODR") and I came across an interesting chapter about designing flexible interfaces. Although I have been using Public and Private methods in my code, I never really looked into "why" there should be a distinction between methods in a Class (at the time I also didn't know what was meant by "interface").

All Classes implement methods that are meant to be used by others (usually more general methods) and methods only designed to be used inside the Class. The methods that are intended to be used by others are part of what's called the Public interface. These methods reveal just enough information about the Class to be useful, they should be unsurprising, dependable and reveal the intentions of the Class they belong to. If a Class reveals too much of itself, consequently, it will end up knowing too much of it's neighbors. This leads to a highly [coupled design](http://en.wikipedia.org/wiki/Coupling_(computer_programming) (in other words: [Spaghetti Code](http://en.wikipedia.org/wiki/Spaghetti_code)).

__So how can we avoid the terrors of Spaghetti Code??__  
One way we can combat the evils of Spaghetti Code is to explicitly classify certain method under the Private interface (which basically means "Do not touch or else!"). The Private interface will contain any methods that are not intended to be used by others, cannot be trusted or depended on, they might also handle implementation details and/or can change for any reason.

__Let's explore what Private means in Ruby!__  
If I use the method [Private](http://ruby-doc.org/core-2.0.0/Module.html#method-i-private) in a Class I would expect any method after it (unless I specifically want it [Public](http://ruby-doc.org/core-2.0.0/Module.html#method-i-public)) to be "uncallable" from outside of the Class. In Ruby this is not true (not sure if this applies to other languages as well). What Private means in Ruby is that a method cannot be called with an explicit receiver.

For example, this will throw an error because I have an explicit receiver calling private_method_here (I will also get an error if I call private_method_here directly).  

{% coderay Explicit Receiver lang:ruby %}
class ExampleClass
  def example_method
    self.private_method_here
  end

private
  def private_method_here
    "You're not suppose to mess with me!"
  end
end

example = Example.new
example.example_method # NoMethodError: private method `private_method_here' called for #<Example:0x007f8cb6019420>
{% endcoderay %}

However, if I call private_method_here with an implicit receiver then no error is thrown!

{% coderay Implicit Receiver lang:ruby %}
class ExampleClass
  def example_method
    private_method_here
  end

  private
  def private_method_here
    "You're not suppose to mess with me!"
  end
end

example = Example.new
example.example_method # "You're not suppose to mess with me!"
{% endcoderay %}

There are also a few other ways to gain access to private_method_here.

{% coderay Private isn't quite so private lol lang:ruby %}
class ExampleClass
  private
  def private_method_here
    'Hello Outside World'
  end
end

example = ExampleClass.new
example.instance_eval{ private_method_here } # "Hello Outside World"
example.send :private_method_here # "Hello Outside World"
{% endcoderay %}

It seems that Private in Ruby acts more like a suggestion rather than being strictly enforced.
