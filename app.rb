require "slack-ruby-bot"
require "dotenv"
require "logger"

Dotenv.load

@log = Logger.new(STDOUT)
class Paparazzi < SlackRubyBot::Bot
  def self.capture
    @log.info("[*] Capture from Webcam...")
    puts ENV["SAVE_DIR"]
    capture = `fswebcam -F 1 -S 20 -r 640x480 #{ENV["SAVE_DIR"]}`
  end

  def self.upload
    @log.info("[*] Upload to server...")
    upload = `scp #{ENV["SAVE_DIR"]} #{ENV["ID"]}@#{ENV["HOST"]}:`
  end

  command "ping" do |c, d, m|
    c.say(text: "#{d["user"]["name"]}", channel: d.channel)
  end

  command "getcam" do |c, d, m|
    @log.info("[*] RUN getcam")
    unless ENV["SOUND_FILE"].empty?
      @log.info("[*] Playing sound for capture...")
      system("mpg321 #{ENV["SOUND_FILE"]}")
    end
    capture
    upload
    c.say(text: "#{ENV["TEXT"]} #{ENV["URL"]}", channel: d.channel)
  end
end

Paparazzi.run
