require "json"
require "stumpy_png"
require "stumpy_core"

module Droppable::Art
  class Trait

    @[JSON::Field(ignore: true)]
    getter canvas : StumpyCore::Canvas?

    include JSON::Serializable

    @[JSON::Field(key: "NAME")]
    property name : String

    @[JSON::Field(key: "FILE")]
    property file : String?

    @[JSON::Field(key: "DIST")]
    property dist : Float64

    @[JSON::Field(key: "EXTRA")]
    property attributes : Hash(String, UInt32)?
  end
end