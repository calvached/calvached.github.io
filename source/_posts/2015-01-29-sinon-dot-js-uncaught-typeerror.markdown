---
layout: post
title: "Sinon.JS Uncaught TypeError"
date: 2015-01-29 16:07:13 -0600
comments: true
categories: [sinon, fakeserver]
---

A few days ago I spent 2-3 hours trying to debug a red warning error. A very cryptic error indeed with no insight on how to fix it. Through a combination of trial and error, asking for help, and flipping tables I was able to find a solution to the problem. Here's what worked for me.
<!-- more -->

Testing Toolbelt: Testem, Jasmine, Jasmine-jQuery and Sinon.JS

* Uncaught TypeError: Fake server request processing threw exception: undefined is not a function at http://localhost:7357/app/bower_components/sinon/index.js, line 907
![Sinon error](http://i.imgur.com/3l5VO8Q.png)

If you'll look at my screenshot you'll notice that there's a strange red error at the bottom. I managed to find the test that was causing the red error and have included it below.

{% coderay lang:javascript %}
it 'executes a trigger', ->
  fakeListener = spyOn(Backbone, "View")
  fakeServer.respondWith(
    'POST'
    'http://localhost:9393/new'
    [200, {}, JSON.stringify({})]
  )

  view = renderSetup()
  view.listenTo(view, 'setupComplete', fakeListener)

  view.$('[data-id=board-size]').val('6')
  view.$('[data-id=play-button]').click()
  fakeServer.respond()

  expect(fakeListener).toHaveBeenCalled()
{% endcoderay %}

The purpose of this is to test whether a trigger happens on the success of a fetch from an endpoint. I set up a fakeServer which has a url of "/new", a status code of 200, and an empty {} as a response. In response I wrote the code below, which results in the red error from the screenshot.

{% coderay lang:ruby %}
 submitBoardSize: (boardSize) ->
    @clearElem()

    @board().fetch
      data: @boardSizeData()
      type: 'POST'
      success: @successCallback
      error: @errorCallback
{% endcoderay %}

There are two possibly reasons why this error occurs, the first being that the context of "this" is not what you would expect it to be, so on the ```@successCallback``` and ```@errorCallback``` this can be corrected by using a ```=>``` instead of the usual ```->```.

{% coderay lang:ruby %}
successCallback: => # fat arrow here
    @trigger('setupComplete')
{% endcoderay %}

The "fat arrow" preserves what "this" is at that given time. The second, has to do with the way the test itself is written. Depending on the context (fetch vs. ajax) the fakeServer must return a specific response. For example if you are calling ```fetch``` on a Model then the fakeServer must return a {} or hash-like object, whereas if you are calling ```fetch``` on a Collection then the fakeServer must return a [] or an array-like structure. On an ```ajax``` call the response can be anything, it does not trigger the red warning because unlike ```fetch```, ```ajax``` does not, by default, update a Model/Collection.
