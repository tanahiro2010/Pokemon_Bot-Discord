require 'discordrb'
require 'json'

str_data = ""
File.open(path="./data/pokemon.json", mode="r") do |file|
  file.each do |text|
    str_data += text
  end
end

$pokemon_data = JSON.parse str_data

str_data = ""
File.open(path="./data/setting.json", mode="r") do |file|
  file.each do |text|
    str_data += text
  end
end
tokens = JSON.parse str_data

Token = tokens["token"]
Client_id = tokens["client_id"]

puts "Token: #{Token}\nClient_id: #{Client_id}"
bot = Discordrb::Bot.new(token: Token, client_id: Client_id)
command = Discordrb::Commands::CommandBot.new(token:Token, client_id:Client_id, prefix: "/")


bot.ready do
  puts "Done login."
end

bot.message do |message|
  msg = message.content
  keys = $pokemon_data.keys
  keys.each do |pokemon|
    if msg.include? pokemon
      message.channel.send $pokemon_data[pokemon]
    end
  end


  if msg.include?("!add pokemon ") && msg[0] == "!"
    cmd = msg.sub! "!add pokemon ", ""

    puts cmd
    data = cmd.split(",")
    name = data[0]
    say = data[1]
    $pokemon_data[name] = say
    File.open(path="./data/pokemon.json", mode="w") do |file|
      file.write JSON.generate $pokemon_data
    end
    message.channel.send("Done add pokemon data.\nThank you!!")
  end
end

command.run true # command追加
bot.run # Login