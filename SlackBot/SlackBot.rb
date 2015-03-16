# -*- coding: utf-8 -*-
#! /usr/bin/env ruby

require 'uri'
require 'net/https'
require 'json'
require 'yaml'

class SlackBot

  def initialize
    @params = YAML.load_file('./setting.yml')
  end

  def get_message
    @params["count"] = 20
    response = slack_api('channels.history', @params)
    message_resource = JSON.parse(response.body)

    return message_resource
  end

  def post_message(msg)
    @params["text"] = msg
    return slack_api('chat.postMessage', @params)
  end

  private
  def slack_api(method, params)
    url = 'https://slack.com/api/' + method
    headers = {  }
    return get_request(url, params, headers)
  end

  def get_request(url, params, headers = {  })
    uri = URI.parse(url)
    https = Net::HTTP.new(uri.host,uri.port)

    https.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)
    request.set_form_data(params)
    res = https.request(request)
    return res
  end
end
