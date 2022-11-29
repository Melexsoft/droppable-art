require "digest/sha1"
require "pixie"
require "stumpy_png"
require "stumpy_core"

module Droppable::Art
  class Image
    include StumpyCore

    property directory : String

    def initialize(working : String)
      @directory = working
    end

    def build(layers : Array(Trait)) : String
      fName : String = fileName(layers)
      target : String = "#{@directory}/build/images/#{fName}.png"
       #canvas : Canvas? = nil
      main : Pixie::ImageSet? = nil
      layers.each do |x|
        # png = StumpyPNG.read("#{@directory}#{x.file}")
        image = loadImage(x)
        if main.nil?
          # canvas = png
          wand = LibMagick.cloneMagickWand(image)
          main =  Pixie::ImageSet.new(wand)
        else
          # canvas.paste(png, 0,0)
          main.composite_image(image, :over, false, 0, 0)
        end
      end
      (main.as(Pixie::ImageSet)).write_image(target)
      # StumpyPNG.write(canvas.as(Canvas), target)
      return fName
    end

    def fileName(layers : Array(Trait)) : String
      return Digest::SHA1.hexdigest(layers.map { |x| x.name }.join(""))
    end

    def loadImage(layer : Trait)
      ImageCache.instance.get("#{@directory}#{layer.file}")
    end
  end
end
