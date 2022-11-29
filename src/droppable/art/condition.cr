require "json"
require "stumpy_png"
require "stumpy_core"

module Droppable::Art
  class Condition

    include JSON::Serializable

    @[JSON::Field(key: "LAYER")]
    property name : String

    @[JSON::Field(key: "REQUIREMENT")]
    property requirement : String

    @[JSON::Field(key: "VALUE")]
    property value : String
    
  end
end