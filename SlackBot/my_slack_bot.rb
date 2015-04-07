#! /usr/bin/env ruby
# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'slack_bot'
require 'pp'

class MySlackBot < SlackBot
  # Add your original functions
  
  def repeat(message)
    m1 = /「/.match(message)
    if m1 != nil then
      m2 = m1.post_match
      m3 = /」と言って/.match(m2)
      if m3 != nil then
        m4 = m3.pre_match
        p m4+" by bot"
        post_message(m4+" by bot")
        repeat(m3.post_match)
      end
    end
  end

end


## sample main

slack = MySlackBot.new("setting.yml")

slack.get_message["messages"].each do |msg|
  slack.repeat(msg["text"])
  #pp msg["text"]
end
