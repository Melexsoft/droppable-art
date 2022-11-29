require "json"

module Droppable::Art
  class Randomizer
    property keys : Array(String)
    property metas : Hash(String, Meta)

    def initialize
      @keys = Array(String).new
      @metas = Hash(String, Meta).new
    end

    def add(key : String, meta : Meta)
      keys.push(key)
      metas[key] = meta
    end

    def write(working, offset)
      i = 1 + offset
      keys.each do |key|
        image_path = "#{working}/build/images/#{key}.png"
        meta_path = "#{working}/build/json/#{i}"
        meta = metas[key]
        meta.image = image_path
        meta.name = meta.name.gsub("{ID}", i.to_s)
        meta.description = meta.description.gsub("{ID}", i.to_s)
        meta.external_url = meta.external_url.gsub("{ID}", i.to_s)
        i += 1
        File.open(meta_path, "w") do |file|
          file.puts meta.to_json
        end
      end
    end

    def write_conf(working, json)
      conf_path = "#{working}/build/image_conf.json"
      File.open(conf_path, "w") do |file|
        file.puts json
      end
    end

    def shuffle
      (Random.rand(10) + 10).times do
        keys.shuffle!(Random::Secure)
      end
    end

    def provenance
      keys.join("")
    end

    def write_provenance(working)
      conf_path = "#{working}/build/provenance.txt"
      File.open(conf_path, "w") do |file|
        file.puts keys.join("")
      end
    end

    def provenance_hash
      Digest::SHA1.hexdigest(provenance)
    end

    def write_provenance_hash(working)
      conf_path = "#{working}/build/provenance_hash.txt"
      File.open(conf_path, "w") do |file|
        file.puts provenance_hash
      end
    end
  end
end
