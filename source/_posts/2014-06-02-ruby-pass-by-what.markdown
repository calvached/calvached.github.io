---
layout: post
title: "Ruby, pass by what?"
date: 2014-06-02 10:12:24 -0500
comments: true
categories: [tech]
---
![david-tennant-confused](http://i.imgur.com/3gQVzL0.gif)

There are two questions that have been bugging me lately. The first, _Why do I have to clone a guess in Mastermind?_ and the second came after I did some research, _What is pass by reference vs. pass by value?_

Let's start with the first question.
<!-- more -->
To simplify what I was experiencing here's an example:  

{% coderay Black magic code going on here lang:ruby %}
class ExampleClass
  def example_method
    var = 'woohooo'

    var.object_id # Object Id: 70131019948560

    x = SomeClass.new
    x.some_method(var)
    x.return_var # returns 'woohooo'

    y = AnotherClass.new
    y.another_method(var)

    x.return_var # returns 'boohooo', whyyy??
  end
end

class SomeClass
  def some_method(var)
    @new_var = var
  end

  def return_var
    @new_var.object_id # Object Id: 70131019948560

    @new_var
  end
end

class AnotherClass
  def another_method(var)
    var[0] = 'b'
    var.object_id # Object Id: 70131019948560

    var
  end
end

j = ExampleClass.new
j.example_method
{% endcoderay %}

So what exactly is going on here? In my ExampleClass I'm passing some_method a variable with the value "woohooo" and I expect it to return the same value (since I'm not making any changes), BUT when I call another_method and pass it the same variable it changes the value that's being returned by return_var. What is this sorcery?!

![Witchcraft black magic code](http://i.imgur.com/PezBytD.gif)

I could easily solve the problem by using the .clone method which creates a copy of the variable and be on my way, but that's not how I roll. This leads us to my second question, _What is pass by reference vs. pass by value?_

After consulting with my long-time friend, Google, what seems to be going on is that each time I'm passing a variable to a method it's not making a copy of the variable, but rather making a copy of the reference to the same object in memory (which is why the Object Ids are all the same). I was absolutely baffled since I had assumed that Ruby makes object copies each time a variable is passed to a method (Oh and by the way this example doesn't work with Fixnum objects, apparently they have "immediate value" which means that the actual object is passed and not a reference).

In this example we see something a little bit different.  

{% coderay Slightly less bewildering code lang:ruby %}
def change(x)
  x.object_id # Object Id: 70266982826660
  x = '10' 
  x.object_id # Object Id: 70266982862600

  x
end

y = '3'
y.object_id # Object Id: 70266982826660

change(y) # returns '10'
y # returns '3'
{% endcoderay %}

I'm passing a variable to the change method and while inside the method I'm assigning it a different value. This method does exactly what I expect it to, it returns a different value, but it leaves the original variable the same. Why? Because the reference is changed (we can see this by looking at the difference in Object Ids) and the return value is actually a completely different object.

In my first example the referenced object value was changed, but in the second example the reference itself was changed. Like I said...witchcraft!

Here's a really great simple analogy that I found.  
{% blockquote Dylan Beattie http://stackoverflow.com/a/430958 StackOverflow %}
Say I want to share a web page with you.

If I tell you the URL, I'm passing by reference. You can use that URL to see the same web page I can see. If that page is changed, we both see the changes. If you delete the URL, all you're doing is destroying your reference to that page - you're not deleting the actual page itself.

If I print out the page and give you the printout, I'm passing by value. Your page is a disconnected copy of the original. You won't see any subsequent changes, and any changes that you make (e.g. scribbling on your printout) will not show up on the original page. If you destroy the printout, you have actually destroyed your copy of the object - but the original web page remains intact.
{% endblockquote %}

TL;DR Ruby is Pass by Value because a copy of a reference to an object is passed and not the object itself.
