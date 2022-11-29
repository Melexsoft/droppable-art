require "json"

module Droppable::Art
  class Meta
    include JSON::Serializable

    @[JSON::Field(key: "name")]
    property name : String

    @[JSON::Field(key: "description")]
    property description : String

    @[JSON::Field(key: "external_url")]
    property external_url : String

    @[JSON::Field(key: "image")]
    property image : String

    @[JSON::Field(key: "dna")]
    property dna : String

    @[JSON::Field(key: "attributes")]
    property breeds : Array(Hash(String, JSON::Any::Type))?

    def self.build_from_obj(_name : String, _description : String, _dna : String, traits : Hash(String, Trait))
      extra = Hash(String, UInt32).new
      json_string = JSON.build do |json|
        json.object do
          json.field "name", _name
          json.field "description", _description
          json.field "external_url", ""
          json.field "image", "image_path"
          json.field "dna", _dna
          if traits.size > 0
            json.field "attributes" do
              json.array do
                traits.each do |key, value|
                  json.object do
                    json.field "trait_type", key
                    json.field "value", value.name
                    if value.attributes != nil
                      value.attributes.as(Hash(String, UInt32)).each do |xKey, xValue|
                        if extra[xKey]? == nil
                          extra[xKey] = xValue
                        else
                          extra[xKey] += xValue
                        end
                      end
                    end
                  end
                end
                if extra.size > 0
                  extra.each do |xkey, xValue|
                    json.object do
                      json.field "trait_type", xkey
                      json.field "value", xValue
                      json.field "display_type", "boost_number"
                    end
                  end
                end
              end
            end
          end
        end
      end
      from_json(json_string)
    end
  end
end
