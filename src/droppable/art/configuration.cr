module Droppable::Art
  class Configuration
    include JSON::Serializable

    @[JSON::Field(key: "START")]
    property start : UInt32

    @[JSON::Field(key: "NAME")]
    property name : String

    @[JSON::Field(key: "DESCRIPTION")]
    property description : String

    @[JSON::Field(key: "URL")]
    property url : String

    @[JSON::Field(key: "BREED")]
    property breeds : Array(Droppable::Art::Breed)

    def generate_images(working : String)
      conf_path = "#{working}/build/image_conf.json"
      metas_path = "#{working}/build/json/"
      image_path = "#{working}/build/images/"
      json_string = File.read(conf_path)
      image_config = Hash(String, Array(Trait)).from_json(json_string)
      Dir.new(metas_path).each do |file|
        next if file == "." || file == ".."
        file_content = File.read(metas_path + file)
        puts "Reading #{file}"
        meta = Meta.from_json(file_content)
        if !File.exists?(image_path + meta.dna + ".png")
          image : Image = Image.new(working)
          layers = image_config[meta.dna]
          puts "Creating image #{meta.dna}"
          image.build(layers)
        else
          puts "Skipping #{meta.dna}.png - exists"
        end
      end
    end

    def generate_meta(working : String) : Array(String)
      result : Array(String) = Array(String).new
      image_config : Hash(String, Array(Trait))
      image_config = Hash(String, Array(Trait)).new
      r = Randomizer.new
      breeds.each do |breed|
        container, condition = breed.gen_dist(working)
        i = 0
        while i < breed.total
          elapsed_time = Time.measure do
            image : Image = Image.new(working)
            selection, traits_list = breed.select(container, condition)
            fname = image.fileName(selection) #image.build(selection)
            image_config[fname] = selection
            meta = Meta.build_from_obj(name, description, fname, traits_list)
            meta.external_url = url
            meta.name = meta.name.gsub("{BREED}", breed.name)
            r.add(fname, meta)
            i += 1
          end
          puts "Eleapsed Time for image: #{elapsed_time}"
        end
      end
      puts "RANDOMIZE ORDER"
      r.shuffle
      puts "WRITING META FILES"
      r.write(working, start)
      r.write_conf(working, image_config.to_json)
      puts "WRITING PROVENANCE"
      r.write_provenance(working)
      puts "WRITING PROVENANCE HASH"
      r.write_provenance_hash(working)
      return result
    end
  end
end
