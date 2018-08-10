# test.rb
require 'http'
require 'json'
require 'eventmachine'
require 'faye/websocket'
require 'date'

# 定数
require './const'
require './weekly_report'
# include('user.rb')

ACTION_MSG_weekly_report = "週報"
ACTION_MSG_HELLO = "こんにちは"


response = HTTP.post("https://slack.com/api/rtm.start", params: {
    token: ENV['SLACK_API_TOKEN']
  })

rc = JSON.parse(response.body)

url = rc['url']

EM.run do
  # Web Socketインスタンスの立ち上げ
  ws = Faye::WebSocket::Client.new(url)

  #  接続が確立した時の処理
  ws.on :open do
    p [:open]
  end

  # RTM APIから情報を受け取った時の処理
  ws.on :message do |event|
  	data = JSON.parse(event.data)
    p [:message, data]
    ######## ↓ロジック↓ ########
    send_text = ''
    send_text = convert_to_weekly_report(data['text']) unless data['text'] == nil

    # send_text = ""
    # send_text = TEMPLATE_STR_weekly_report if data['text'] != nil and data['text'].include?(ACTION_MSG_weekly_report)
    # send_text = "こんにちは <@#{data['user']}> さん" if data['text'] != nil and data['text'].include?(ACTION_MSG_HELLO)
    ####### ↑ロジック↑ ########
    unless send_text.empty?
    	# ロジックの追加
    	ws.send({
    		type: 'message',
    		text: send_text,
    		channel: data['channel']
    	}.to_json)
    end
  end

  # 接続が切断した時の処理
  ws.on :close do
    p [:close, event.code]
    # ws = nil
    EM.stop
  end

end