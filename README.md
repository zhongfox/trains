[![Build Status](https://travis-ci.org/zhongfox/trains.svg?branch=master)](https://travis-ci.org/zhongfox/trains)

This set of classes is intended to solve the trains problem. The lib directory contains the source code, the spec directory contains the rpsec test code.

The main design is using ruby object-oriented, and breadth-first search.

Tested ok with `ruby 2.1.1p76` and `rspec 2.14.1`

* The classes introduction

  * Route: represents the single route between 2 stops
  * Path: represents the continuous routes
  * StopMap: represents the routes and the stops set
  * StopRelation: represents the relation of 2 stops, with a specified StopMap

* How to use the example

  cd to trains directory, run the test example using `ruby trains_test.rb`, you will see the output, with some additional usage.

* How  To run The test

  cd to trains directory, make sure `bundle install` successfully, then run the rpsec tests using `rspec spec`.
