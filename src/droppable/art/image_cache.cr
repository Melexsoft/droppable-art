require "pixie"

module Droppable::Art
    class ImageCache

        property cache : Hash(String, Pixie::ImageSet)
        def initialize
            @cache = Hash(String, Pixie::ImageSet).new
        end

        def get(file : String)
            cache[file] ||=Pixie::ImageSet.new(file)
        end

        def self.instance
            @@image_cache ||=new
        end
    end
end