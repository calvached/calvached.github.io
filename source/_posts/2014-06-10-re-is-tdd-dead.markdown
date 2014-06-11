---
layout: post
title: "Re: Is TDD Dead?"
date: 2014-06-10 11:14:52 -0500
comments: true
categories: [TDD, DHH, Kent Beck, Martin Fowler, isTDDDead]
---
![Zombie TDD](http://i.imgur.com/N2unFYi.jpg)

After listening to [Is TDD Dead?](http://martinfowler.com/articles/is-tdd-dead/) and attending DHH's [talk](http://www.confreaks.com/videos/3315-railsconf-keynote-writing-software) during RailsConf I have come to the conclusion that TDD is great as long as you test the right thing in the right way. Here's why.
<!-- more -->
**What is TDD?**  
{% img right http://i.imgur.com/FYmJLP9.png Place Kitten #2 %}
TDD (Test-Driven Development) is a software development process in which you write a failing test that defines a desired outcome, write code to make the test pass, refactor and repeat.

Although this seems simple enough, for a TDD beginner (such as myself) it is very easy to begin by testing the wrong things or the right things, but in the wrong way (it is also equally as easy to get flamed for writing bad tests). Theses sorts of tests can lead to false security, loss of time and could be worse than not testing at all. Therefore, good tests will produce good code and poor tests will produce poor code. But there is hope!

{% blockquote @elight https://twitter.com/elight/status/475121094450757633 Twitter %}
You don’t learn to write good tests without first writing poor tests. Period.
{% endblockquote %}

A lot of the difficulty in doing TDD has to do with understanding how to design things well. It requires in-depth knowledge of OO design, patterns, SOLID, DRY, etc. Failure to throughly understand these principles will result in poor tests. Another pain point with TDD is that there are also a lot of opinions on how to do TDD, what should and should not be tested, what constitutes a good/bad test, level of abstraction, etc. As a beginner this can be confusing and at times overwhelming because there isn't one right answer (if any at all).

My battle plan for TDD: spiking it out. Thinking through the code by writing it out will help me to visualize where and what to test.

<!-- TDD provides us with guidelines to help us think about design problems.-->