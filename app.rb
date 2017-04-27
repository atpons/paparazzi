require "slack-ruby-bot"
require "dotenv"

Dotenv.load

class Paparazzi < SlackRubyBot::Bot
  command "ping" do |c, d, m|
    c.say(text: "pong", channel: d.channel)
  end
end

Paparazzi.run
