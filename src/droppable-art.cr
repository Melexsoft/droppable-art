require "json"
require "option_parser"
require "./droppable/art/*"


# Starting Point
module Droppable::Art
  VERSION = "0.1.0"
  myfolder = ""
  skip = false
  OptionParser.parse do |parser|
    parser.banner = "Welcome to The Beatles App!"

    parser.on "-v", "--version", "Show version" do
      puts "version #{VERSION}"
      exit
    end
    parser.on "-h", "--help", "Show help" do
      puts parser
      exit
    end
    parser.on "-d FOLDER", "--goodbye_hello=FOLDER", "parsing folder" do |folder|
      myfolder = folder
    end

    parser.on "-s SKIP", "--skip=SKIP", "skipping image_conf_gen, only image creation" do |s|
      skip = (s == "true")
    end
  end

  p = Parser.new(myfolder, skip)
  p.run
end