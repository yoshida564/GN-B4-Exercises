# -*- coding: utf-8 -*-

require 'uri'
require 'net/https'
require 'json'
require 'yaml'

class SlackBot

  def initialize(config_file_name = "setting.yml")
    @config = YAML.load_file(config_file_name)
  end

  # See https://api.slack.com/methods for Slack API reference

  def get_message(count = 20)
    response = slack_api('channels.history', {"count" => count})
    message_resource = JSON.parse(response.body)

    return message_resource
  end

  def post_message(msg)
    return slack_api('chat.postMessage', {"text" => msg})
  end

  private

  def slack_api(method, params = {})
    url = 'https://slack.com/api/' + method
    headers = {}
    params = params.merge(@config)
    return get_request(url, params, headers)
  end

  def get_request(url, params, headers = {})
    uri = URI.parse(url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)
    request.set_form_data(params)
    res = https.request(request)
    return res
  end
end
