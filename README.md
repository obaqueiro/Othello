# Othello-Ruby ![alt text][travis] ![alt text][codecov] [![Maintainability](https://api.codeclimate.com/v1/badges/18b653d8e24ea578bfaa/maintainability)](https://codeclimate.com/github/phil0s0pher/Othello/maintainability)
Ruby version of Othello board game

### Requirements

ruby  
gosu

The versions used for testing were:  
ruby version 2.1.5  
gosu version 0.8.6  

### Running on Mac

1. Install sdl2  via `brew install sdl2`
2. Install "bundler" via `gem install bundler` 
3. Run `bundle install`
4. Run  `ruby lib/window.rb` 

### Operation

To run the game go to your command prompt change directories to the directory containing the Othello_run.rb. When in said directory type "ruby Othello_run.rb" and press enter. Example 
	D:\Dropbox\Othello  ruby Othello.rb
When the game window appears, you will be have two prompts for the player names. 
Type your name and then press the return key.
The rest of the game uses the mouse.
Click the space you want to put your piece in.
To close the game press "c" and to reset press "r" 

### Comments or futher work
The game works as it should. In the future I would like to add multiple states for the window 
to make a better GUI.

### Attributations

All images included were created by me using Gimp 2


[travis]:https://travis-ci.org/phil0s0pher/Othello.svg?branch=master
[codacy]:https://api.codacy.com/project/badge/Grade/03a3cfd677e640dca0aaf0502672dcfb
[codecov]:https://codecov.io/gh/phil0s0pher/Othello/branch/master/graph/badge.svg
