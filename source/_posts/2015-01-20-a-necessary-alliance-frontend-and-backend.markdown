---
layout: post
title: "A necessary alliance: Frontend &amp; Backend"
date: 2015-01-20 10:19:18 -0600
comments: true
categories: [tech, frontend, backend, framework]
---

Throughout my apprenticeship I've primarily worked with Backend languages and technologies (such as [Ruby](https://www.ruby-lang.org/en/) and [Sinatra](http://www.sinatrarb.com/)), so when my mentor had me start working with [Backbone](http://backbonejs.org/) the concept of a frontend framework was utterly baffling. This was my first step into learning the workings of a Distributed System.
<!-- more -->

All I knew about frontend at the time were the primary tools: HTML, CSS, and Javascript. I didn't know how the backend actually talked to the frontend (How does the exchange of information happen?) or what jobs and duties the frontend was in charge of (At which point does the frontend end and the backend take over?). I had a vague idea as to what asynchronous and synchronous were. But most importantly, where exactly does all this code live?

###What is Frontend (aka. The Client)?
Frontend is the part of the code that directly interacts with the user, it's the point of contact for an application. Everytime a user visits a site they are directly interacting with the client by scrolling, clicking, inputing data, etc. Its primary goal is to interact and present data in a well defined way. The code lives on your computer via your browser of choice.

###What is Backend (aka. The Server)?
The backend handles all the complex logic, such interacting with the server and database. It's goal is to answer a request and return a response to the frontend. Server-side languages such as Ruby, Java, and Python are used to build the backend. Any data you see displayed on the frontend was served through backend code which lives on the server.

###How do these two work together?
Let's take Amazon.com as an example. You enter the url of "www.amazon.com" and a request from your browser is sent to a server somewhere. The server responds with some HTML, CSS, and Javascript. Your browser uses this response to render the HTML and shortly after loads the CSS and Javascript. Viola! We have the Amazon.com homepage!

![Amazon](http://i.imgur.com/BVQqZuF.png)

When you enter a search term in the search bar and press ENTER or click Go, another request is sent from the frontend to the server and the response comes back as search results, which are then nicely rendered onto the page.

![Search Results](http://i.imgur.com/3Z2kaNk.png)

###Now let's look a bit deeper...
I mentioned Backbone at the beginning of this post so now let's define what it is and why it's used. Backbone is a frontend framework*, it provides structure to what otherwise would be a tangled ball of callbacks. It uses Models and Collections to handle data responses from the backend and Views for handling anything related to the DOM (Document Object Model). There are multiple ways that Backbone can send a request to the server, but I'll only be talking about two, [AJAX](http://api.jquery.com/jquery.ajax/) and ```fetch```. AJAX is the [jQuery](http://jquery.com/) way of sending a request, you specify the request type (GET/POST), an endpoint/route/url, and of course any data that you want to send over.

Let's say we have a Collection called "Library" and inside this "Library" we have various Models called "Book". If I wanted to add a new "Book" to my "Library" I have to send in my "Book" data to the server.

{% coderay AJAX example in Coffeescript lang:coffeescript %}
  $.ajax 'http://localhost:9393/library/new',
    type: 'POST'
    data: {'title': 'The Importance of Being Earnest', 'author': 'Oscar Wilde'}
    dataType: 'json'
    error: @errorCallback()
    success: @successCallback()
{% endcoderay %}

This method is quite common and will work just fine for most requests, but the Model/Collection will have to be manually updated each time you receive a successful response. Fortunately Backbone comes built in with ```fetch``` for a darn good reason. Remember that "Library" I talked about a second ago? Perfect, well a ```fetch``` can be called on an instance of a "Library", it's technically an AJAX request behind the scenes, but it also updates the data in my "Library" with a new "Book" on a successful response.

{% coderay fetch example in Coffeescript lang:coffeescript %}
  @library.fetch
    url: 'http://localhost:9393/library/new'
    type: 'POST'
    data: {'title': 'The Importance of Being Earnest', 'author': 'Oscar Wilde'}
    error: @errorCallback()
    success: @successCallback()
{% endcoderay %}

A quick visual overview on how the frontend and backend communicate with each other.

![frontend-backend-visual](http://i.imgur.com/890WdGu.gif)

* Wikipedia: "A framework is a universal, reusable software environment that provides particular functionality as part of a larger software platform to facilitate development of software applications, products and solutions"
<!--
AJAX (hit a route or endpoint)
ENDPOINTS (matching)
Should there be any critical or complex logic happening at the Frontend?
-->
