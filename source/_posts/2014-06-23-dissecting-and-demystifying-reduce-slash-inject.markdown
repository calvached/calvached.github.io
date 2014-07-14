---
layout: post
title: "Dissecting and Demystifying: Reduce/Inject"
date: 2014-06-23 16:30:29 -0500
comments: true
categories: [tech, D&D, reduce]
---
[Reduce](http://www.ruby-doc.org/core-2.1.0/Enumerable.html#method-i-reduce) (a.k.a. Inject) is an enumerable method that recently made a whole lot of sense to me, so I figured that it was time to do a deep dive into how ```reduce``` works and what it can do for us using Blocks and Symbols.
<!-- more -->

###Block
 ```reduce``` takes three arguments: a collection, an initial value, and a function. If an initial value isn't given then it defaults to the first value in the collection.
{% coderay Integer as initial value lang:ruby %}
def add_numbers
  (1..10).reduce(0) { |sum, value| sum + value }
end

def add_more_numbers
  (1..10).reduce { |sum, value| sum + value }
end


add_numbers # returns 55
add_more_numbers # returns 55
{% endcoderay %}
In ```add_numbers``` the arguments are as follows:  
__Collection__: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10  
__Initial Value__: 0  
__Function__: Add each element from the collection to the initial value and return a total.

 ```reduce``` initializes the variable "sum" with the value of 0 and keeps a running total of each return value. In other words, a number from the collection is added each time to the initial value and the total sum becomes the new sum for the next value waiting to be added.

Let's see what this example looks like using ```each``` instead:
{% coderay Using an each method lang:ruby %}
def add_numbers
  sum = 0

  (1..10).each { |value| sum += value }
  sum
end

add_numbers # returns 55
{% endcoderay %}
 ```reduce``` is like an ```each``` with superpowers!

Our initial value can also be an array or a hash.

{% coderay Array as an initial value lang:ruby %}
def even_numbers
  (1..10).reduce([]) do |even_arr, value|
    value.even? ? even_arr << value : even_arr
  end
end

even_numbers # returns [2, 4, 6, 8, 10]

# SIDE NOTE: There must always be a return value or else the accumulator will be returned as "nil"
{% endcoderay %}

{% coderay Hash as an initial value lang:ruby %}
def change_structure(data)
  data.reduce({}) do |results_hash, element|
    results_hash[element[0]] = element[1]
    results_hash
  end
end

user_info = [['username', 'carlsagan'], ['password','palebluedot']]
change_structure(user_info) # returns {"username"=>"carlsagan", "password"=>"palebluedot"}
{% endcoderay %}

###Symbol
 ```reduce``` also accepts a symbol, which makes addition and multiplication very easy and simple to read.

{% coderay lang:ruby %}
(1..10).reduce(:+) # returns 55
(1..10).reduce(1, :+) # returns 56
{% endcoderay %}
The ```:``` tells Ruby that we are going to give it a symbol, which in our case is a ```+``` (this is the name of the addition method, you can also give it a ```*``` for the multiplication method). By passing in a symbol we can apply a method to each one of the values in the collection.

The operator methods can be broken down as follows:
{% coderay lang:ruby %}
10.+( 2 ) # returns 12
10.*( 2 ) # returns 20
10.-( 2 ) # returns 8
10./( 2 ) # returns 5
{% endcoderay %}
