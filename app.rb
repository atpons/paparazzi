require "slack-ruby-bot"
require "dotenv"
require "logger"

Dotenv.load

@log = Logger.new(STDOUT)
class Paparazzi < SlackRubyBot::Bot
  def self.capture
    puts "[*] Capture from Webcam..."
    puts ENV["SAVE_DIR"]
    capture = `fswebcam -F 1 -S 20 -r 640x480 #{ENV["SAVE_DIR"]}`
  end

  def self.upload
    puts "[*] Upload to server..."
    upload = `scp #{ENV["SAVE_DIR"]} #{ENV["ID"]}@#{ENV["HOST"]}:`
  end

  command "ping" do |c, d, m|
    c.say(text: "pong", channel: d.user)
  end

  command "getcam" do |c, d, m|
    puts "[*] RUN getcam from #{d.channel}"
    capture
    upload
    c.say(text: "#{ENV["TEXT"]} #{ENV["URL"]}", channel: d.channel)
  end
end

Paparazzi.run
