#! /usr/bin/env ruby
# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'slack_bot'
require 'pp'

class MySlackBot < SlackBot
  # Add your original functions
end


## sample main

slack = MySlackBot.new("setting.yml")

slack.get_message.each do |msg|
  pp msg
end
