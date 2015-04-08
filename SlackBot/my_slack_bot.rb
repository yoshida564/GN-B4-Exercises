#! /usr/bin/env ruby
# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'slack_bot'
require 'pp'

class MySlackBot < SlackBot
  # Add your original functions
  
  def repeat(message) #一行に複数には対応　入れ子は未対応
    m1 = /「/.match(message) 
    if m1 then
      m2 = m1.post_match
      m3 = /」と言って/.match(m2)
      if m3 then
        m4 = m3.pre_match
        p m4+" by bot"
        post_message(m4+" by bot")
        repeat(m3.post_match)
      end
    end
  end

  def weather(message)
#複数の地名はcase文の上の方のものが優先される
    case message
    when /岡山/ then
      city = 330010
      place = "岡山"
    when /東京/ then
      city = 130010
      place = "東京"
    when /大阪/ then
      city = 270000
      place = "大阪"
    when /徳島/ then
      city = 360010
      place = "徳島"
    else
      city = 330010 #デフォルトで岡山県岡山市
      place = "岡山"
    end

    url = 'http://weather.livedoor.com/forecast/webservice/json/v1?city='+city.to_s
    response = my_get_request(url)
    msg = JSON.parse(response)
#複数の日付はそれぞれの日付の天気を別々にpostする
    msg["forecasts"].each do |fore|
      if (message =~ /今日/) && (fore["dateLabel"] == "今日") then
        date = fore["date"]
        weat = fore["telop"]
        post_message("今日 ("+date+") の"+place+"の天気は "+weat+" だよ．by bot")
        p "今日 ("+date+") の"+place+"の天気は "+weat+" だよ．by bot"
      elsif (message =~ /明日/) && (fore["dateLabel"] == "明日") then
        date = fore["date"]
        weat = fore["telop"]
        post_message("明日 ("+date+") の"+place+"の天気は "+weat+" だよ．by bot")
        p "明日 ("+date+") の"+place+"の天気は "+weat+" だよ．by bot"
      elsif (message =~ /明後日/) && (fore["dateLabel"] == "明後日") then
        date = fore["date"]
        weat = fore["telop"]
        post_message("明後日 ("+date+") の"+place+"の天気は "+weat+" だよ．by bot")
        p "明後日 ("+date+") の"+place+"の天気は "+weat+" だよ．by bot"
      end
    end
  end

  def my_get_request(url)
    uri = URI.parse(url)
    request = Net::HTTP.get(uri)
    return request
  end

end


## sample main

slack = MySlackBot.new("setting.yml")

slack.get_message["messages"].each do |msg|
  next if msg["text"] =~ /by bot$/i
  if (msg["text"] =~ /天気/) then
    slack.weather(msg["text"])
  end
  slack.repeat(msg["text"])
  #pp msg["text"]
end
