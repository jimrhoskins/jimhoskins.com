---
layout: post
title: "Different Stacks: Treehouse Code Challenges"
---

*The Different Stacks series covers the different software and library
  stacks I have experimented with, and how it goes together*


While we were getting ready to launch [Treehouse][treehouse], I was
given the opportunity to build a brand new component, Code Challenges.
We had already decided to incorporate badges via multiple choice quizzes
in Treehouse, but then it became clear that we really needed a way to
demonstrate your knowledge by actually coding. Since Alan had more than
enough on his plate, and I was in search of a project, Code Challenges
became my baby.

We decided that the challenges should be developed as a separate
application that would be embedded into the Treehouse pages via an
iframe or JavaScript. This had two main benefits: first I could develop
independently of the main Treehouse code base, which was iterating
extremely fast, but more importantly I had full control over what
software, libraries, and frameworks I would use to build. Here is the
stack I ended up going with.




* [NodeJS][node]
* [ExpressJS][express]
* [CoffeeScript][coffeescript] (everywhere)
* [CouchDB][couchdb]
* [Dojo / Dijit][dojo]
* [Ace][ace]
* [RequireJS][require]
* [Jade][jade]
* [Stylus][stylus]
* [Handlebars][handlebars]

Now I want to explain how these components worked together in a real
application.

## Require.JS + Dojo + Ace Editor

The code challenge interface is a fairly complex interface with many
components including tabs, a rich code editor with multiple instances 
, and challenge interface. All of these components need to be able to
communicate effectively. There are a lot of moving parts in th
application, so organizing all this code is important. One huge js file
isn't going to cut it. I decided to give [require.js][require] a try.
This provided me the ability to split my code into multiple modules,
with all of the dependency management handled for me.

Require.js was a great choice, particularly because my two main external
libraries ([Ace][ace] and [Dojo][dojo]) follow the same [Asynchronous
Module Definition][amd] pattern that require.js follows. This means
instead of loading a large compiled file that includes all of the
library into my app, I can require components from ace and dojo just
like I would require any of my own modules.

Getting ace and dojo into my project was a bit tricky. The require.js
website has a guide to using dojo with require. It really just came down
to checking out the correct tag of the libraries. 

This combination was nice because I don't have any global objects to
rely on from my modules, so the dependency graph is fairly easy to
reason about.

## CoffeeScript + Dojo

I decided to commit to using [CoffeeScript][coffee] throughout this
project. I had experimented with CoffeeScript before, but I wanted to
see how well it held up in a larger project. It's awesome, and it
changes the way you program and think about problems. One of the biggest
shifts is how CoffeeScript comprehensions make [map][map] and [select/filter][select] 
operations easy without another library like [underscore][underscore].

My favorite sugar in CoffeeScript comes from its class syntax. It is
nice because it provides a pretty familiar syntax for creating classes
(or rather constructor functions) in JavaScript, while having the
implementation be pretty much the standard for prototypal inheritance.
It even implements a `super` keyword that works very well.

One of the surprise benefits of the class sugar is how it easily
replaced dojo's subclassing mechanism. Most of my classes are subclasses
of the various dojo widgets that override certain callbacks in the
lifecycle to serve my application needs. The suggested way of
subclassing in dojo is the following.

    dojo.provide('mynamespace.MyButton);
    dojo.define('mynamespace.MyButton', dijit.Button {
      postCreate: function () {
        // widget element has been created, setup in here
      }
    });

This pattern is by no means the worst implementation I've seen, but one
thing I don't care for is the provide/define that will place my class
into the global repository of classes. With require, I want all my
classes to be local to the module, then specifically exported. The other
complaint is that dojo can't name the constructor function after your
class, so when debugging, the default "class" name for an object won't
be MyButton, but something more cryptic. CoffeeScript classes actually
produce the correctly named constructor function, so the representation
in the console or `.toString()` will match the name of you class.

The CoffeeScript that would create a class is this, and it not only
looks cleaner, but also addresses the scope and naming problems.

    class MyButton extends dijit.Button
      postCreate: ->
        # widget element has been created, setup in here

Bam! The extend keyword works without issue. Without a constructor
defined, it will automatically call the parent's constructor when `new
MyButton` is executed. If I want to override any methods, including the
constructor, I can do it very easily. Again the `super` keyword works as
expected.


# Node + Express + CouchDB

[Node.js][node] powers the server with [Express][express] handling
routes and middleware. I don't have much to say about this, it's pretty
much the standard Node stack, and I have very little serve logic in this
app.

The one awesome component that I do want to talk about is
[CouchDB][couchdb]. Couch turns out to be an ideal datastore for the
editor because all my queries are key/value lookups. There isn't any
real searching or complex queries. The data I need to store is pretty
varied, as any given challenge template or editing session may have any
number of "files" associated with it. Converting it to JSON and throwing
it into the couch is about as easy as it gets.

Here's the cool part: the server doesn't have (almost) anything to do
with the server. Couch uses HTTP to work with it, and the browser speaks
HTTP, so my frontend talks directly to the database.

Due to the [same domain policy][same-domain] of the browser, the
frontend can't talk directly to the database, but it can if the server
acts as a dumb proxy to the database. The [http-proxy][http-proxy]
library made this trivial to do in Node. There is a little bit of
middleware that runs some basic authorization checks on the queries, but
that's it. There's no real "API" on my server, just the API of the
database exposed through a proxy. 


# Jade + Stylus + Handlebars

[Jade][jade] and [Handlebars][handlebars] are templating languages. They
actually didn't get much use in this project since the interface is
largely constructed with Dojo widgets. The main server template is
basically an empty html page with a couple of JavaScript and CSS
includes. I used handlebars in a couple of places where I needed to
create some arbitrary HTML and constructing it programatically would
have been silly. Both are great.

[Stylus][stylus] is a language the compiles to css, much like
[SASS][sass], but with an even more minimalistic syntax. It works quite
well. 

# Final Thoughts

Overall I am pretty satisfied with this stack. It has been one of the
most organized front-end project I have had the chance to work on.
Jumping back in after several weeks away from the code has been pretty
painless. It's easy to get (re)oriented in the code.

The require.js compiler did have a few quirks that I had to work through
when I was getting the app ready for launch. Most of these problems were
easy to resolve, and the cost was worth the benefit to me.


What do you think? Have you used any of these technologies in your
projects? What are your experiences?



  [node]: http://nodejs.org
  [express]: http://expressjs.com
  [coffeescript]: http://coffeescript.org
  [couchdb]: http://couchdb.org
  [dojo]: http://dojotoolkit.org
  [ace]: http://ace.ajax.org
  [require]: http://requirejs.org
  [jade]: http://jade-lang.com
  [stylus]: http://learnboost.github.com/stylus/
  [handlebars]: http://www.handlebarsjs.com/
  [treehouse]: http://teamtreehouse.com/
  [amd]: https://github.com/amdjs/amdjs-api/wiki/AMD
  [same-domain]: http://en.wikipedia.org/wiki/Same_origin_policy
  [sass]: http://sass-lang.com/
  [http-proxy]: https://github.com/nodejitsu/node-http-proxy
  [underscore]: http://documentcloud.github.com/underscore/
