require "json"
require "stumpy_png"
require "stumpy_core"

module Droppable::Art
  class Layer

    @[JSON::Field(key: "CONDITION")]
    property condition : Condition?

    @[JSON::Field(key: "TRAITS")]
    property traits : Array(Trait)

    include JSON::Serializable

  end
end