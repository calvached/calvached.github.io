---
layout: post
title: "Ruby, pass by what?"
date: 2014-06-02 10:12:24 -0500
comments: true
published: false
categories: []
---

There are two questions that have been bugging me lately. The first, "Why do I have to clone a guess in Mastermind?" and the second came after I did some research, "What is pass by reference vs. pass by value?"

Let's start with the first question.
<!-- more -->

<!-- I came across an 

Ruby memory allocation (where does ruby store objects and why do I have to clone a guess in Mastermind?)
Variable references

http://stackoverflow.com/a/430958

Say I want to share a web page with you.

If I tell you the URL, I'm passing by reference. You can use that URL to see the same web page I can see. If that page is changed, we both see the changes. If you delete the URL, all you're doing is destroying your reference to that page - you're not deleting the actual page itself.

If I print out the page and give you the printout, I'm passing by value. Your page is a disconnected copy of the original. You won't see any subsequent changes, and any changes that you make (e.g. scribbling on your printout) will not show up on the original page. If you destroy the printout, you have actually destroyed your copy of the object - but the original web page remains intact.

http://stackoverflow.com/questions/373419/whats-the-difference-between-passing-by-reference-vs-passing-by-value
http://www.ruby-doc.org/core-2.1.2/Fixnum.html
http://blog.khd.me/ruby/ruby-pass-by-value-or-by-reference/ -->