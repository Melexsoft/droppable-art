require "file_utils"
 
module Droppable::Art
    class Parser

        property parsed : Configuration
        property working : String
        property skip : Bool

        def initialize(folder : String, _skip : Bool)
            @working = folder
            file_content = File.read(folder + "/meta.json")
            @parsed = Configuration.from_json(file_content)
            @skip = _skip
        end

        def run
            FileUtils.mkdir_p(working+"/build")
            FileUtils.mkdir_p(working+"/build/images")
            FileUtils.mkdir_p(working+"/build/json")
            if skip
                puts "Skipping Meta Gen"
            else
                puts "Building Meta"
                parsed.generate_meta(working)
            end
            parsed.generate_images(working)
        end
    end
end